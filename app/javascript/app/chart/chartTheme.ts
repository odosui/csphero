import { Chart } from "chart.js";

import { directiveColorToken } from "../directives/directiveColor";

function token(name: string) {
  return getComputedStyle(document.documentElement)
    .getPropertyValue(name)
    .trim();
}

export function directiveColor(name: string) {
  return token(directiveColorToken(name));
}

export function applyChartTheme() {
  Chart.defaults.font.family = token("--font-ui");
  Chart.defaults.font.size = 12;
  Chart.defaults.color = token("--color-text-muted");
  Chart.defaults.borderColor = token("--color-border");
  Chart.defaults.plugins.legend.labels.usePointStyle = true;
  Chart.defaults.plugins.legend.labels.boxHeight = 6;
  Chart.defaults.plugins.tooltip.backgroundColor = token("--color-text");
  Chart.defaults.plugins.tooltip.cornerRadius = 10;
  Chart.defaults.plugins.tooltip.padding = 10;
  Chart.defaults.plugins.tooltip.usePointStyle = true;
  Chart.defaults.elements.line.borderWidth = 2;
  // smooth, but never overshooting below zero or above a peak
  Chart.defaults.elements.line.cubicInterpolationMode = "monotone";
  Chart.defaults.elements.point.radius = 0;
  Chart.defaults.elements.point.hoverRadius = 4;
}
