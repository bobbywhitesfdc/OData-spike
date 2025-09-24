#!/bin/bash
# ProcessBuilder_usage.sh
# Extracts ObjectName, FlowName, FlowVersion, Type, AfterInsert, AfterUpdate, AfterDelete
# from Process Builder flows

OUTPUT="ProcessBuilders.csv"
DEBUG=false

log_debug() {
  if $DEBUG; then
    echo "[DEBUG] $1" >&2
  fi
}

extract_field() {
  local file="$1"
  local xpath_expr="$2"
  xpath -q -e "$xpath_expr" "$file" 2>/dev/null | sed -n 's/^[[:space:]]*//p' | head -n1
}

determine_phases() {
  local file="$1"
  local ai="N" au="N" ad="N"

  local matches
  matches=$(xpath -q -e "//formulas/expression/text()" "$file" 2>/dev/null || true)

  if echo "$matches" | grep -q "ISNEW("; then
    ai="Y"
    log_debug "Found ISNEW() → AfterInsert=Y"
  else
    log_debug "No ISNEW() found"
  fi

  if echo "$matches" | grep -q "ISCHANGED("; then
    au="Y"
    log_debug "Found ISCHANGED() → AfterUpdate=Y"
  else
    log_debug "No ISCHANGED() found"
  fi

  if echo "$matches" | grep -q "ISDELETED("; then
    ad="Y"
    log_debug "Found ISDELETED() → AfterDelete=Y"
  else
    log_debug "No ISDELETED() found"
  fi

  echo "$ai,$au,$ad"
}

process_file() {
  local file="$1"

  local status
  status=$(extract_field "$file" "//status/text()")
  if [[ "$status" != "Active" ]]; then
    log_debug "Skipping $file (status=$status)"
    return
  fi

  local objectName flowName flowVersion phases
  objectName=$(extract_field "$file" "//processMetadataValues[name='ObjectType']/value/stringValue/text()")
  flowName=$(extract_field "$file" "//label/text()")
  flowVersion=$(extract_field "$file" "//apiVersion/text()")
  phases=$(determine_phases "$file")

  echo "$objectName,$flowName,$flowVersion,ProcessBuilder,$phases"
}

main() {
  echo "ObjectName,FlowName,FlowVersion,Type,AfterInsert,AfterUpdate,AfterDelete" > "$OUTPUT"

  for file in force-app/main/default/flows/*.flow-meta.xml; do
    log_debug "Processing $file"
    process_file "$file" >> "$OUTPUT"
  done
}

if [[ "$1" == "--debug" ]]; then
  DEBUG=true
fi

main
