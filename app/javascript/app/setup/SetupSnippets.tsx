import * as React from "react";
import { useState } from "react";
import CopyBlock from "../components/copy/CopyBlock";
import SNIPPETS from "./snippets";

const SetupSnippets: React.FC<{ endpoint: string }> = ({ endpoint }) => {
  const [selectedId, setSelectedId] = useState(SNIPPETS[0].id);
  const snippet = SNIPPETS.find((s) => s.id === selectedId) ?? SNIPPETS[0];

  return (
    <div className="setup-snippets">
      <div className="snippet-tabs" role="tablist">
        {SNIPPETS.map((s) => (
          <button
            type="button"
            role="tab"
            key={s.id}
            aria-selected={s.id === snippet.id}
            className={s.id === snippet.id ? "active" : ""}
            onClick={() => setSelectedId(s.id)}
          >
            {s.label}
          </button>
        ))}
      </div>
      <div className="instructions-block" role="tabpanel">
        {snippet.file && <label className="endpoint-label">{snippet.file}</label>}
        <CopyBlock value={snippet.code(endpoint)} />
        {snippet.note && <p className="snippet-note">{snippet.note}</p>}
        {snippet.guideUrl && (
          <a
            className="snippet-guide"
            href={snippet.guideUrl}
            target="_blank"
            rel="noreferrer"
          >
            Full {snippet.label} guide: nonces, stricter directives and more
          </a>
        )}
      </div>
    </div>
  );
};

export default SetupSnippets;
