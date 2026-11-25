import django from "./django";
import express from "./express";
import headers from "./headers";
import nextjs from "./nextjs";
import nginx from "./nginx";
import rails from "./rails";
import type { SetupSnippet } from "./types";

const SNIPPETS: [SetupSnippet, ...SetupSnippet[]] = [
  headers,
  rails,
  nextjs,
  django,
  express,
  nginx,
];

export default SNIPPETS;
