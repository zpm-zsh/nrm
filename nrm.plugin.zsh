#!/usr/bin/env zsh


function _nrm_publish {
  _arguments -s -A "-*"                                       \
  '(-t --tag)'{-t,--tag}'[Add tag]'                           \
  '(-a --access)'{-a,--access}'[Set access]'                  \
  '(-o --otp)'{-o,--otp}'[Set otpcode]'                       \
  '(-dr --dry-run)'{-dr,--dry-run}'[Set is dry run]'          \
  '(-h --help)'{-h,--help}'[Output usage information]'        \
  
}

local _repo
local name
local description
typeset -g _nrm_repos
_nrm_repos=()
nrm ls | sed 's/^..//' | sed -r '/^\s*$/d' | awk '{print $1" "$3}' | while read _repo; do
  name="$(echo $_repo | awk '{print $1}' )"
  description="$(echo $_repo | awk '{print $2}' )"
  _nrm_repos+="${name}:${description}"
done

typeset -g _nrm_commands
_nrm_commands=(
  'ls:List all the registries'
  'current:Show current registry name'
  'use:Change registry to registry'
  'add:Add one custom registry'
  'set-auth:Set authorize information for a custom registry with a base64 encoded string or username and pasword'
  'set-email:Set email for a custom registry'
  'set-hosted-repo:Set hosted npm repository for a custom registry to publish packages'
  'del:Delete one custom registry'
  'home:Open the homepage of registry with optional browser'
  'publish:Publish package to current registry if current registry is a custom registry'
  'test:Show response time for specific or all registries'
  'help:Print help'
)

_nrm(){
    
  if (( CURRENT == 2 )); then
    
    _nrm_args=(
      '(-h --help)'{-h,--help}'[Show help information]'
      '(-v --version)'{-v,--version}'[output the version number]'
    )
  else
    
    _nrm_args=(
      '(-h --help)'{-h,--help}'[Show help information]'
    )
    
  fi
  
  
  _arguments -s -A "-*"              \
  "${_nrm_args[@]}"                  \
  '*:: :->subcmds' && return 0
  
  if (( CURRENT == 1 )); then
    _describe -t commands 'Commands' _nrm_commands
    return
  fi
  
  if (( CURRENT > 1 )); then
    
    case "$words[1]" in
      use|del|home|set-auth|set-email|set-hosted-repo)
        _describe -t commands "Nrm repos" _nrm_repos
      ;;
      publish)
        _nrm_publish
      ;;
      *)
        return
      ;;
    esac
    
  fi
}

compdef _nrm nrm
