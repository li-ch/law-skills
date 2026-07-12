#!/bin/bash
set -e

echo "Installing LAW skills for OpenCode..."

SKILLS_DIR="${HOME}/.opencode/skills"
COMMON_DIR="${HOME}/.common-law"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "${SKILLS_DIR}"
mkdir -p "${COMMON_DIR}/bib"
mkdir -p "${COMMON_DIR}/paper-style"

# Install shared state
echo "  → common-law shared state"
cp -r "${SCRIPT_DIR}/common-law/bib/"* "${COMMON_DIR}/bib/"
cp -r "${SCRIPT_DIR}/common-law/paper-style/"* "${COMMON_DIR}/paper-style/"

# Install all 10 skills
for skill in law-bootstrap law-build law-call4expr law-pagecount law-resubmit law-review law-revise law-upstream law-verify law-write; do
    echo "  → ${skill}"
    rm -rf "${SKILLS_DIR}/${skill}"
    cp -r "${SCRIPT_DIR}/${skill}" "${SKILLS_DIR}/${skill}"
done

echo ""
echo "Done. 10 LAW skills installed to ${SKILLS_DIR}"
echo "Shared state installed to ${COMMON_DIR}"
echo ""
echo "Restart OpenCode to activate the skills."
