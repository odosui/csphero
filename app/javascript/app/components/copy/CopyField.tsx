import * as React from "react";
import { CheckIcon, CopyIcon } from "../icons";
import useCopy from "./useCopy";

const CopyField: React.FC<{ value: string }> = ({ value }) => {
  const [copied, copy] = useCopy();

  return (
    <div className="copy-field">
      <code>{value}</code>
      <button
        type="button"
        className="humble copy-btn"
        onClick={() => copy(value)}
      >
        {copied ? <CheckIcon /> : <CopyIcon />}
        {copied ? "Copied" : "Copy"}
      </button>
    </div>
  );
};

export default CopyField;
