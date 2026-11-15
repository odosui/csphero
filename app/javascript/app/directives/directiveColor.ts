// One colour per directive, shared by badges and chart lines, so a directive
// looks the same wherever it appears. Known directives get a hand-picked slot;
// anything else hashes into the palette.
const PALETTE_SIZE = 12;

const KNOWN: Record<string, number> = {
  "script-src": 1,
  "style-src": 2,
  "font-src": 3,
  "img-src": 4,
  "script-src-attr": 5,
  "script-src-elem": 6,
  "frame-src": 7,
  "media-src": 8,
  "style-src-elem": 9,
  "default-src": 10,
  "connect-src": 11,
  "style-src-attr": 12,
};

function hashSlot(name: string) {
  let hash = 0;
  for (const char of name) hash = (hash * 31 + char.charCodeAt(0)) >>> 0;
  return (hash % PALETTE_SIZE) + 1;
}

export function directiveColorToken(name: string) {
  return `--chart-${KNOWN[name] ?? hashSlot(name)}`;
}
