# BRAG integration

- Upstream repository: https://github.com/latent-spaces/brag.git
- Installed source commit: `4068e38cb0733e42beeb74df5e3c5eee1b4e9163`
- Installed with the upstream-documented `npx skills add` global install method.
- Shared source: `C:\Users\HP\.agents\skills\brag\SKILL.md`
- Codex discovery: `C:\Users\HP\.codex\skills\brag` junction to the shared source.
- OpenCode discovery: `C:\Users\HP\.config\opencode\skills\brag` resolves through the existing shared skills junction.
- Lock file: `C:\Users\HP\.agents\.skill-lock.json`
- Rollback backup: `C:\Users\HP\.agents\.backup-brag-20260920-001525\`

## Verified prerequisites

- Node.js `v24.20.0` (upstream requires 22+)
- FFmpeg `9.0.1`
- Git `2.55.0.windows.3`
- Hyperframes `0.8.51`; `npx --yes hyperframes doctor` passed core checks.

Hyperframes reports optional local components (whisper-cpp, Kokoro TTS, MusicGen) as absent and Docker as not running. These are not required for the default BRAG workflow; voice/local fallback and Docker-dependent workflows remain unavailable until separately installed/enabled.

## Integration policy

BRAG was added to the existing shared skills source rather than duplicating or replacing agent configuration. `sync-adapters.ps1` was run afterward; the shared-layer verifier passed with 26 skills and 26 Codex junctions. Existing Codex/OpenCode instruction files were preserved; their rollback copies are in the backup directory above.
