import * as React from "react";
import { CheckIcon, CopyIcon } from "../icons";
import useCopy from "./useCopy";

const CopyBlock: React.FC<{ value: string }> = ({ value }) => {
  const [copied, copy] = useCopy();
  const label = copied ? "Copied" : "Copy";

  return (
    <div className="copy-block">
      <button
        type="button"
        className="copy-btn"
        aria-label={label}
        title={label}
        onClick={() => copy(value)}
      >
        {copied ? <CheckIcon /> : <CopyIcon />}
      </button>
      <pre>
        <code>{value}</code>
      </pre>
    </div>
  );
};

export default CopyBlock;
