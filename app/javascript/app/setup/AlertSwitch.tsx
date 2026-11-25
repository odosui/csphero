import * as React from "react";

const AlertSwitch: React.FC<{
  id: string;
  label: string;
  description: string;
  checked: boolean;
  onChange: (checked: boolean) => void;
}> = ({ id, label, description, checked, onChange }) => (
  <label className="alert-switch" htmlFor={id}>
    <span className="alert-switch-text">
      <b>{label}</b>
      <span>{description}</span>
    </span>
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

export default AlertSwitch;
