export default function reportEndpoint(token: string) {
  return `${window.location.origin}/report/${token}`;
}
