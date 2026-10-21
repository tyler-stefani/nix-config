import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { CustomEditor, keyText } from "@earendil-works/pi-coding-agent";
import { HStack, type Component, Key, isViewportTUI, matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { execFile } from "node:child_process";
import { basename } from "node:path";

const SIDEBAR_WIDTH = 40;
const MIN_TERM_WIDTH = 100;
const MAX_FILES = 12;

/** CustomEditor with a rounded box (corners + side borders), like the sidebar. */
class RoundedEditor extends CustomEditor {
	render(width: number): string[] {
		if (width < 2) return super.render(width);
		const inner = width - 2;
		const lines = super.render(inner);
		const border = (s: string) => this.borderColor(s);
		const pad = (line: string) => line + " ".repeat(Math.max(0, inner - visibleWidth(line)));
		// Structure: [top border, ...visible content, bottom border, ...autocomplete].
		const visibleCount = (this as any).renderedVisibleLineCount ?? 0;
		const bottomIndex = 1 + visibleCount;
		return lines.map((line, index) => {
			const body = pad(line);
			if (index === 0) return `${border("╭")}${body}${border("╮")}`;
			if (index === bottomIndex) return `${border("╰")}${body}${border("╯")}`;
			if (index < bottomIndex) return `${border("│")}${body}${border("│")}`;
			return line;
		});
	}
}

// Group display names for the dynamic cheat sheet. Actions themselves are
// enumerated from pi's keybinding registry at runtime (see CheatSheet).
const GROUP_LABELS: Record<string, string> = {
	app: "Application",
	editor: "Editor",
	input: "Input",
	select: "Selection",
	altScreen: "Fullscreen transcript",
};

function groupFor(action: string): string {
	const [namespace, segment] = action.split(".");
	if (namespace === "app") return GROUP_LABELS.app;
	if (!segment) return "Other";
	return GROUP_LABELS[segment] ?? segment.charAt(0).toUpperCase() + segment.slice(1);
}

function resolveKey(action: string): string {
	try {
		return keyText(action as any);
	} catch {
		return "";
	}
}

const OVERLAY_HEIGHT_FRACTION = 0.8;

class CheatSheet implements Component {
	private readonly rows: { heading: boolean; key: string; desc: string; action?: string }[] = [];
	private readonly keyWidth: number;
	private offset = 0;

	constructor(
		private readonly theme: any,
		private readonly keybindings: any,
		private readonly viewportHeight: () => number,
		private readonly close: () => void,
		private readonly onShortcut: (data: string) => void,
	) {
		let keyWidth = 0;
		const groups = new Map<string, { heading: boolean; key: string; desc: string; action?: string }[]>();
		const definitions = keybindings?.definitions ?? {};
		for (const action of Object.keys(definitions)) {
			if ((keybindings?.getKeys?.(action) ?? []).length === 0) continue;
			const key = resolveKey(action);
			if (!key) continue;
			const desc = keybindings?.getDefinition?.(action)?.description ?? action;
			const title = groupFor(action);
			let list = groups.get(title);
			if (!list) {
				list = [];
				groups.set(title, list);
			}
			list.push({ heading: false, key, desc, action });
			keyWidth = Math.max(keyWidth, visibleWidth(key));
		}
		for (const [title, list] of groups) {
			this.rows.push({ heading: true, key: "", desc: title });
			this.rows.push(...list);
			this.rows.push({ heading: false, key: "", desc: "" });
		}
		this.keyWidth = keyWidth;
	}

	private pageSize(): number {
		return Math.max(4, Math.floor((this.viewportHeight() || 24) * OVERLAY_HEIGHT_FRACTION) - 5);
	}

	handleInput(data: string): void {
		if (matchesKey(data, Key.escape) || data === "?") {
			this.close();
			return;
		}
		// Navigation keys scroll the sheet before any shortcut is considered.
		const page = this.pageSize();
		const maxOffset = Math.max(0, this.rows.length - page);
		if (matchesKey(data, Key.up) || data === "k") {
			this.offset = Math.max(0, this.offset - 1);
			return;
		}
		if (matchesKey(data, Key.down) || data === "j") {
			this.offset = Math.min(maxOffset, this.offset + 1);
			return;
		}
		if (matchesKey(data, Key.pageUp)) {
			this.offset = Math.max(0, this.offset - page);
			return;
		}
		if (matchesKey(data, Key.pageDown)) {
			this.offset = Math.min(maxOffset, this.offset + page);
			return;
		}
		if (matchesKey(data, Key.home)) {
			this.offset = 0;
			return;
		}
		if (matchesKey(data, Key.end)) {
			this.offset = maxOffset;
			return;
		}
		// Pressing a listed key closes the sheet and runs it (lazygit-style).
		for (const r of this.rows) {
			if (r.action && this.keybindings?.matches?.(data, r.action)) {
				this.onShortcut(data);
				return;
			}
		}
	}

	invalidate(): void {
		/* rendered fresh */
	}

	render(width: number): string[] {
		const theme = this.theme;
		const w = Math.max(24, width);
		const contentWidth = Math.max(1, w - 4);
		const border = (s: string) => theme.fg("borderAccent", s);
		const pad = (s: string): string => {
			const vw = visibleWidth(s);
			return vw >= contentWidth ? truncateToWidth(s, contentWidth, "…") : s + " ".repeat(contentWidth - vw);
		};
		const row = (s: string): string => `${border("│")} ${pad(s)} ${border("│")}`;
		const center = (s: string): string =>
			row(" ".repeat(Math.max(0, Math.floor((contentWidth - visibleWidth(s)) / 2))) + s);

		const page = this.pageSize();
		this.offset = Math.max(0, Math.min(this.offset, Math.max(0, this.rows.length - page)));
		const window = this.rows.slice(this.offset, this.offset + page);
		const padKey = (k: string): string => k + " ".repeat(Math.max(0, this.keyWidth - visibleWidth(k)));

		const out: string[] = [center(theme.bold(theme.fg("accent", "Keyboard shortcuts")))];
		out.push(row(theme.fg("dim", "↑↓/jk scroll · page up/down · esc close · press a listed key to run it")));
		out.push(row(""));
		for (const r of window) {
			if (r.heading) out.push(row(theme.bold(theme.fg("accent", r.desc))));
			else if (!r.key && !r.desc) out.push(row(""));
			else out.push(row(`${theme.fg("dim", padKey(r.key))} ${theme.fg("text", r.desc)}`));
		}
		while (out.length < page + 3) out.push(row(""));
		const rule = "─".repeat(Math.max(0, w - 2));
		return [border(`╭${rule}╮`), ...out, border(`╰${rule}╯`)];
	}
}

let cheatSheetOpen = false;

async function toggleCheatSheet(ctx: any): Promise<void> {
	if (cheatSheetOpen) return;
	cheatSheetOpen = true;
	try {
		await ctx.ui.custom<void>(
			(tui: any, theme: any, keybindings: any, done: () => void) => {
				const sheet = new CheatSheet(
					theme,
					keybindings,
					() => tui.terminal.rows ?? 24,
					done,
					(data: string) => {
						// Close first so focus returns to the editor, then replay the key.
						done();
						setTimeout(() => tui.handleTerminalInput?.(data), 0);
					},
				);
				return {
					render: (w: number) => sheet.render(w),
					invalidate: () => sheet.invalidate(),
					handleInput: (data: string) => {
						sheet.handleInput(data);
						tui.requestRender();
					},
				};
			},
			{ overlay: true, overlayOptions: { width: "70%", minWidth: 52, maxHeight: "80%", anchor: "center" } },
		);
	} finally {
		cheatSheetOpen = false;
	}
}

const PI_LOGO = [
	"████████████████",
	"████████████████",
	"  ████    ████  ",
	"  ████    ████  ",
	"  ████    ████  ",
	"  ████    ████  ",
];

interface GitFile {
	code: string;
	path: string;
}

function parseGitStatus(out: string): GitFile[] {
	const files: GitFile[] = [];
	for (const line of out.split("\n")) {
		if (!line) continue;
		const code = line.slice(0, 2);
		let path = line.slice(3);
		const arrow = path.indexOf(" -> ");
		if (arrow !== -1) path = path.slice(arrow + 4);
		files.push({ code, path });
	}
	return files;
}

function fmtTokens(n: number): string {
	if (n < 1000) return `${n}`;
	if (n < 10000) return `${(n / 1000).toFixed(1)}k`;
	if (n < 1000000) return `${Math.round(n / 1000)}k`;
	return `${(n / 1000000).toFixed(1)}M`;
}

function ellipsizeLeft(s: string, width: number): string {
	if (visibleWidth(s) <= width) return s;
	if (width <= 1) return "…";
	return `…${s.slice(s.length - (width - 1))}`;
}

/** Turn `git diff HEAD --shortstat` output into a compact `+X −Y lines` label. */
function parseShortStat(out: string): string | undefined {
	const m = out.match(/(\d+) files? changed(?:, (\d+) insertions?\(\+\))?(?:, (\d+) deletions?\(-\))?/);
	if (!m) return undefined;
	return `+${m[2] ?? "0"} −${m[3] ?? "0"} lines`;
}

class Sidebar implements Component {
	private files: GitFile[] = [];
	private error: string | undefined;
	private diffStat: string | undefined;
	private loading = false;

	constructor(
		private readonly ctx: any,
		private readonly footerData: any,
		private readonly tui: any,
	) { }

	refreshGit(): void {
		if (this.loading) return;
		this.loading = true;
		try {
			execFile(
				"git",
				["status", "--porcelain=v1", "-uall"],
				{ cwd: this.ctx.cwd, timeout: 2500, maxBuffer: 1 << 20, encoding: "utf8" },
				(err, stdout) => {
					if (err) {
						this.files = [];
						this.error = "not a git repository";
						this.diffStat = undefined;
						this.loading = false;
						this.tui.requestRender();
						return;
					}
					this.files = parseGitStatus(stdout);
					this.error = undefined;
					// Second call keeps the panel visibly live when the same files are
					// edited repeatedly (the path list alone would not change).
					execFile(
						"git",
						["diff", "HEAD", "--shortstat"],
						{ cwd: this.ctx.cwd, timeout: 2500, maxBuffer: 1 << 20, encoding: "utf8" },
						(statErr, statOut) => {
							this.diffStat = statErr ? undefined : parseShortStat(statOut);
							this.loading = false;
							this.tui.requestRender();
						},
					);
				},
			);
		} catch {
			this.loading = false;
		}
	}

	private totalCost(): number {
		let cost = 0;
		try {
			for (const entry of this.ctx.sessionManager.getEntries()) {
				if (entry.type === "message" && entry.message?.role === "assistant") {
					cost += entry.message.usage?.cost?.total ?? 0;
				}
			}
		} catch {
			/* session not ready */
		}
		return cost;
	}

	private shortCwd(): string {
		const cwd: string = this.ctx.cwd;
		const home = process.env.HOME || process.env.USERPROFILE;
		return home && cwd.startsWith(home) ? `~${cwd.slice(home.length)}` : cwd;
	}

	private hyperStatus(): string | undefined {
		try {
			const text = this.footerData.getExtensionStatuses?.()?.get?.("hyper");
			return text ? text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim() : undefined;
		} catch {
			return undefined;
		}
	}

	invalidate(): void {
		/* rendered fresh every frame */
	}

	/** Compact one-block summary used in regular (non-fullscreen) mode. */
	renderCompact(width: number): string[] {
		const theme = this.ctx.ui.theme;
		const branch = this.footerData.getGitBranch?.();
		const cwd: string = this.ctx.cwd;

		const head =
			`${theme.fg("accent", "π")} ${theme.bold(theme.fg("text", basename(cwd) || cwd))} ` +
			`${theme.fg("dim", this.shortCwd())}` +
			(branch ? ` ${theme.fg("muted", `(${branch})`)}` : "");

		const model = this.ctx.model;
		const usage = this.ctx.getContextUsage?.();
		let stats = theme.fg("muted", model?.id ?? "no model");
		if (usage) {
			const pct = usage.percent;
			const pctStr = pct === null || pct === undefined ? "?" : `${pct.toFixed(1)}%`;
			const color = pct !== null && pct !== undefined && pct > 90 ? "error" : pct !== null && pct !== undefined && pct > 70 ? "warning" : "success";
			stats +=
				` ${theme.fg("dim", "ctx")} ${theme.fg("text", fmtTokens(usage.tokens ?? 0))}` +
				`${theme.fg("dim", `/${fmtTokens(usage.contextWindow)}`)} ${theme.fg(color, pctStr)}`;
		}
		stats += ` ${theme.fg("dim", "cost")} ${theme.fg("text", `$${this.totalCost().toFixed(4)}`)}`;
		const hyper = this.hyperStatus();
		if (hyper) stats += `  ${hyper}`;

		let changes: string;
		if (this.error) {
			changes = theme.fg("dim", `changes ${this.error}`);
		} else if (this.files.length === 0) {
			changes = theme.fg("dim", "changes working tree clean");
		} else {
			const shown = this.files.slice(0, 4).map((f) => {
				const { label, color } = statusBadge(f.code);
				return `${theme.fg(color, label)} ${theme.fg("text", basename(f.path))}`;
			});
			const more = this.files.length > 4 ? ` ${theme.fg("dim", `+${this.files.length - 4} more`)}` : "";
			const stat = this.diffStat ? ` ${theme.fg("dim", this.diffStat)}` : "";
			changes = `${theme.fg("muted", `changes (${this.files.length})`)}${stat} ${shown.join("  ")}${more}`;
		}

		return [head, stats, changes].map((line) => truncateToWidth(line, width, "…"));
	}

	render(width: number): string[] {
		const theme = this.ctx.ui.theme;
		const w = Math.max(4, width);
		const height = Math.max(4, this.tui.terminal.rows ?? 24);
		const contentWidth = Math.max(1, w - 4);
		const border = (s: string) => theme.fg("borderAccent", s);

		const pad = (s: string): string => {
			const vw = visibleWidth(s);
			return vw >= contentWidth ? truncateToWidth(s, contentWidth, "…") : s + " ".repeat(contentWidth - vw);
		};
		const row = (s: string): string => `${border("│")} ${pad(s)} ${border("│")}`;
		const blank = (): string => row("");
		const center = (s: string): string => {
			const left = Math.max(0, Math.floor((contentWidth - visibleWidth(s)) / 2));
			return row(" ".repeat(left) + s);
		};
		const section = (label: string): string => theme.bold(theme.fg("accent", label));

		const body: string[] = [];
		body.push(blank());
		for (const line of PI_LOGO) body.push(center(theme.fg("accent", line)));
		body.push(blank());

		// Directory
		const cwd: string = this.ctx.cwd;
		body.push(row(section("DIRECTORY")));
		body.push(row(theme.bold(theme.fg("text", basename(cwd) || cwd))));
		body.push(row(theme.fg("muted", this.shortCwd())));
		body.push(blank());

		// Model
		const model = this.ctx.model;
		body.push(row(section("MODEL")));
		body.push(row(theme.fg("text", model?.id ?? "no model")));
		if (model?.provider) body.push(row(theme.fg("dim", model.provider)));
		const usage = this.ctx.getContextUsage?.();
		if (usage) {
			const pct = usage.percent;
			const pctStr = pct === null || pct === undefined ? "?" : `${pct.toFixed(1)}%`;
			const color = pct !== null && pct !== undefined && pct > 90 ? "error" : pct !== null && pct !== undefined && pct > 70 ? "warning" : "success";
			const ctxLine = `${theme.fg("muted", "ctx")} ${theme.fg("text", fmtTokens(usage.tokens ?? 0))}${theme.fg("dim", `/${fmtTokens(usage.contextWindow)}`)} ${theme.fg(color, pctStr)}`;
			body.push(row(ctxLine));
		}
		body.push(row(`${theme.fg("muted", "cost")} ${theme.fg("text", `$${this.totalCost().toFixed(4)}`)}`));
		const hyper = this.hyperStatus();
		if (hyper) body.push(row(hyper));
		body.push(blank());

		// Changes
		const branch = this.footerData.getGitBranch?.();
		const title = this.files.length ? `CHANGES (${this.files.length})` : "CHANGES";
		body.push(row(section(title)));
		if (branch) body.push(row(theme.fg("muted", `⎇ ${branch}`)));
		if (this.diffStat) body.push(row(theme.fg("muted", this.diffStat)));
		if (this.error) {
			body.push(row(theme.fg("dim", this.error)));
		} else if (this.files.length === 0) {
			body.push(row(theme.fg("dim", "working tree clean")));
		} else {
			for (const file of this.files.slice(0, MAX_FILES)) {
				const { label, color } = statusBadge(file.code);
				body.push(row(`${theme.fg(color, label)} ${theme.fg("text", ellipsizeLeft(file.path, contentWidth - 2))}`));
			}
			if (this.files.length > MAX_FILES) {
				body.push(row(theme.fg("dim", `+${this.files.length - MAX_FILES} more`)));
			}
		}

		const lines: string[] = [];
		const rule = "─".repeat(Math.max(0, w - 2));
		lines.push(border(`╭${rule}╮`));
		const bodyHeight = height - 2;
		for (let i = 0; i < bodyHeight; i++) lines.push(body[i] ?? blank());
		lines.push(border(`╰${rule}╯`));
		return lines;
	}
}

function statusBadge(code: string): { label: string; color: string } {
	if (code === "??") return { label: "?", color: "dim" };
	const c = code.trim();
	if (c.includes("U") || c === "AA" || c === "DD") return { label: "!", color: "error" };
	if (c.startsWith("A")) return { label: "+", color: "success" };
	if (c.startsWith("D")) return { label: "−", color: "error" };
	if (c.startsWith("R")) return { label: "→", color: "accent" };
	return { label: "~", color: "warning" };
}

if (process.env.PI_SIDEBAR_SELFTEST) {
	const parsed = parseGitStatus(" M a/b.ts\n?? result\nR  old -> new\n");
	const ok =
		parsed.length === 3 &&
		parsed[0].code === " M" &&
		parsed[0].path === "a/b.ts" &&
		parsed[1].code === "??" &&
		parsed[2].path === "new" &&
		statusBadge(" M").label === "~" &&
		statusBadge("??").label === "?" &&
		statusBadge("A ").label === "+" &&
		statusBadge("D ").label === "−" &&
		statusBadge("R ").label === "→" &&
		statusBadge("UU").label === "!";
	console.log(ok ? "sidebar selftest ok" : `sidebar selftest FAILED: ${JSON.stringify(parsed)}`);
	process.exit(ok ? 0 : 1);
}

interface Active {
	interval: ReturnType<typeof setInterval>;
	unsub?: () => void;
	unsubInput?: () => void;
	unmount: () => void;
	clearWidget: () => void;
	clearEditor: () => void;
}

let active: Active | null = null;
let currentSidebar: Sidebar | null = null;

function teardown(): void {
	currentSidebar = null;
	if (!active) return;
	clearInterval(active.interval);
	try {
		active.unsub?.();
		active.unsubInput?.();
		active.clearWidget();
		active.unmount();
		active.clearEditor();
	} catch {
		/* TUI may already be gone */
	}
	active = null;
}

/** Hide the footer row in the fullscreen dock so the editor meets the bottom. */
function hideFooterRow(root: any): void {
	const dock = (root?.entries ?? [])
		.map((entry: any) => entry?.component)
		.find((component: any) => Array.isArray(component?.entries));
	const dockEntries = dock?.entries;
	if (Array.isArray(dockEntries) && dockEntries.length > 0) {
		dockEntries[dockEntries.length - 1].visible = () => false;
	}
}

/** Mount the sidebar as a real right-hand column in the fullscreen layout root. */
function mountFullscreen(tui: any, sidebar: Sidebar): () => void {
	const root = tui.layoutRoot;
	hideFooterRow(root);
	const stack = new HStack([
		{ component: root, basis: 0, grow: 1, shrink: 1, minSize: 20 },
		{
			component: sidebar,
			basis: SIDEBAR_WIDTH,
			grow: 0,
			shrink: 0,
			minSize: SIDEBAR_WIDTH,
			maxSize: SIDEBAR_WIDTH,
			visible: (viewport) => viewport.width >= MIN_TERM_WIDTH,
		},
	]);
	tui.setLayoutRoot(stack);
	return () => tui.setLayoutRoot(root);
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("keys", {
		description: "Show keyboard shortcut cheat sheet",
		handler: async (_args, ctx) => {
			if (ctx.mode !== "tui") return;
			await toggleCheatSheet(ctx);
		},
	});

	pi.registerCommand("changes", {
		description: "Refresh the git changes panel",
		handler: async (_args, ctx) => {
			if (ctx.mode !== "tui" || !ctx.hasUI) return;
			currentSidebar?.refreshGit();
		},
	});

	// Refresh promptly after the agent touches files instead of waiting up to 2s.
	pi.on("tool_result", () => {
		currentSidebar?.refreshGit();
	});
	pi.on("turn_end", () => {
		currentSidebar?.refreshGit();
	});

	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui" || !ctx.hasUI) return;
		teardown();
		ctx.ui.setEditorComponent(
			(tui, theme, keybindings) => new RoundedEditor(tui, theme, keybindings, { embedWorkingStatus: true }),
		);
		ctx.ui.setFooter((tui, _theme, footerData) => {
			const sidebar = new Sidebar(ctx, footerData, tui);
			currentSidebar = sidebar;
			sidebar.refreshGit();

			let unmount: () => void = () => { };
			if (isViewportTUI(tui) && (tui as any).layoutRoot) {
				unmount = mountFullscreen(tui, sidebar);
			} else {
				// Regular mode has no layout root; show a compact block above the editor.
				ctx.ui.setWidget("crush-sidebar", (_widgetTui, _widgetTheme) => ({
					render: (w: number) => sidebar.renderCompact(w),
					invalidate() { },
				}));
			}

			const interval = setInterval(() => sidebar.refreshGit(), 2000);
			const unsub = footerData.onBranchChange?.(() => tui.requestRender());
			const unsubInput = ctx.ui.onTerminalInput((data) => {
				if (data !== "?") return undefined;
				const focused: any = (tui as any).getFocusedComponent?.();
				if (!focused || typeof focused.getText !== "function") return undefined;
				if (ctx.ui.getEditorText().length > 0 || cheatSheetOpen) return undefined;
				if (typeof ctx.isIdle === "function" && !ctx.isIdle()) return undefined;
				setTimeout(() => void toggleCheatSheet(ctx), 0);
				return { consume: true };
			});
			active = {
				interval,
				unsub,
				unsubInput,
				unmount,
				clearWidget: () => ctx.ui.setWidget("crush-sidebar", undefined),
				clearEditor: () => ctx.ui.setEditorComponent(undefined),
			};
			return {
				render: () => [],
				invalidate() { },
				dispose() {
					teardown();
				},
			};
		});
	});

	pi.on("session_shutdown", () => {
		teardown();
	});
}
