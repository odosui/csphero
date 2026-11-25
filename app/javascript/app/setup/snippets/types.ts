export type SetupSnippet = {
  id: string;
  label: string;
  // where the code goes, e.g. a config file
  file?: string;
  guideUrl?: string;
  note?: string;
  code: (endpoint: string) => string;
};

export const STARTER_POLICY = "default-src 'self'";
