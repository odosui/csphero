import type { FC } from "react";
import FilterField from "./FilterField";

type Props = {
  id: string;
  label: string;
  placeholder: string;
  value: string | null | undefined;
  multiline?: boolean;
  onChange: (value: string | null) => void;
};

// A filter value is always one line, so Enter never adds a break. A
// `multiline` field is still drawn tall and wrapping, for long URIs.
const TextFilter: FC<Props> = ({
  id,
  label,
  placeholder,
  value,
  multiline = false,
  onChange,
}) => {
  const shared = {
    id,
    placeholder,
    spellCheck: false,
    value: value ?? "",
  };

  return (
    <FilterField label={label} htmlFor={id}>
      {multiline ? (
        <textarea
          {...shared}
          className="text-filter multiline"
          rows={3}
          onChange={(e) => onChange(e.target.value.replace(/\n/g, "") || null)}
          onKeyDown={(e) => e.key === "Enter" && e.preventDefault()}
        />
      ) : (
        <input
          {...shared}
          type="text"
          className="text-filter"
          onChange={(e) => onChange(e.target.value || null)}
        />
      )}
    </FilterField>
  );
};

export default TextFilter;
