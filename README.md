# caser.vim

Easily change word casing with motions, text objects or visual mode.

This plugin is largely inspired by Tim Pope's [vim-abolish](https://github.com/tpope/vim-abolish), and aims to improve its casing functionality to better blend with Vim's editing philosophy.

## Table of contents

1. [Installation](#installation)
1. [Usage](#installation)
    - [Limitations](#limitations)
    - [Global options](#global-options)

## Installation

`vim-caser` may be installed by any of your favourite plugin managers. Be it Pathogen, Vundle or Plug, use whichever you prefer.

For example, when using with [Plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'arthurxavierx/vim-caser'
```

## Usage

`vim-caser` makes it easy to convert between multiple word casings, from `camelCase` to `snake_case` to `Title Case`, it blends nicely with Vim's editing features such as _motions_, _text objects_ and _visual mode_.

All mappings below must be followed by a motion or a text object, or be applied within visual mode.

 Case | Default Mapping | Plug Mapping (normal/visual)
------|-----------------|------------------------------
`MixedCase` or `PascalCase`  | `gsm` or `gsp` | `<Plug>CaserMixedCase`/`<Plug>CaserVMixedCase`
`camelCase`  | `gsc` | `<Plug>CaserCamelCase`/`<Plug>CaserVCamelCase`
`snake_case` | `gs_` | `<Plug>CaserSnakeCase`/`<Plug>CaserVSnakeCase`
`UPPER_CASE` | `gsu` or `gsU` | `<Plug>CaserUpperCase`/`<Plug>CaserVUpperCase`
`Title Case` | `gst` | `<Plug>CaserTitleCase`/`<Plug>CaserVTitleCase`
`Sentence case` | `gss` | `<Plug>CaserSentenceCase`/`<Plug>CaserVSentenceCase`
`space case` | `gs<space>` | `<Plug>CaserSpaceCase`/`<Plug>CaserVSpaceCase`
`dash-case` or `kebab-case` | `gs-` or `gsk` | `<Plug>CaserKebabCase`/`<Plug>CaserVKebabCase`
`Title-Dash-Case` or `Title-Kebab-Case` | `gsK` | `<Plug>CaserTitleKebabCase`/`<Plug>CaserVTitleKebabCase`
`dot.case`   | `gs.` | `<Plug>CaserDotCase`/`<Plug>CaserVDotCase`

The `gs` prefix can be changed through the option `g:caser_prefix`. Alternatively, the default mappings can be disabled by setting `g:caser_no_mappings`.

### Limitations
Currently `vim-caser` only supports the casing options displayed in the table above. If you would like to have another casing option in `vim-caser`, please feel free to create an issue in this repository, or to submit a pull request with the feature properly documented.

### Global options
 Name | Default | Description
------|---------|-------------
`g:caser_prefix` | `gs` | The prefix of all mappings created by `vim-caser`. E.g.: `gsc`, `gs-`, `gsu`, etc.
`g:caser_no_mappings` | not set | Set to `1` to disable default mappings. Custom mappings can be set using the `<Plug>` mappings.
