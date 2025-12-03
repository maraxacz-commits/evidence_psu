/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL: string
  // více env proměnných sem můžeš přidat
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
