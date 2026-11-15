import type { FC } from "react";
import { directiveColorToken } from "../directives/directiveColor";

const DirectiveBadge: FC<{ name?: string | null }> = ({ name }) => {
  if (!name) return null;

  return (
    <span
      className="directive-badge"
      style={{ borderColor: `var(${directiveColorToken(name)})` }}
    >
      {name}
    </span>
  );
};

export default DirectiveBadge;
