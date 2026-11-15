import type { FC, ReactNode } from "react";

const FilterField: FC<{
  label: string;
  htmlFor?: string;
  children: ReactNode;
}> = ({ label, htmlFor, children }) => (
  <div className="filter">
    <label htmlFor={htmlFor}>{label}</label>
    {children}
  </div>
);

export default FilterField;
