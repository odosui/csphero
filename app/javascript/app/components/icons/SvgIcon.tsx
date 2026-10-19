import type { FC, ReactNode } from "react";

export interface IconProps {
  className?: string;
}

const SvgIcon: FC<IconProps & { children: ReactNode }> = ({
  className,
  children,
}) => (
  <svg
    className={className ? `icon ${className}` : "icon"}
    viewBox="0 0 24 24"
    aria-hidden="true"
    focusable="false"
  >
    {children}
  </svg>
);

export default SvgIcon;
