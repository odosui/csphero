import * as React from "react";

import type { Range } from "./useFilters";
import Dropdown from "./components/Dropdown";
import FilterField from "./filters/FilterField";

const OPTIONS = [
  { id: "24h", label: "Last 24 hours" },
  { id: "7d", label: "Last 7 days" },
  { id: "30d", label: "Last 30 days" },
  { id: "90d", label: "Last 90 days" },
];

const TimeRangeFilter: React.FC<{
  value: Range;
  onChange: (value: Range) => void;
}> = ({ value, onChange }) => (
  <FilterField label="Time range">
    <Dropdown
      options={OPTIONS}
      value={value}
      onSelect={(value) => onChange(value as Range)}
    />
  </FilterField>
);

export default TimeRangeFilter;
