import type { FC } from "react";

const SwitchFilter: FC<{
  id: string;
  label: string;
  hint?: string;
  checked: boolean;
  onChange: (checked: boolean) => void;
}> = ({ id, label, hint, checked, onChange }) => (
  <label className="switch-filter" htmlFor={id} title={hint}>
    <span>{label}</span>
    <input
      id={id}
      type="checkbox"
      role="switch"
      className="switch"
      checked={checked}
      onChange={(e) => onChange(e.target.checked)}
    />
  </label>
);

export default SwitchFilter;
