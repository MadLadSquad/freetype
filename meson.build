#
# Meson project file for FreeType 2
#

# Copyright (C) 2020-2024 by
# David Turner, Robert Wilhelm, and Werner Lemberg.
#
# This file is part of the FreeType project, and may only be used, modified,
# and distributed under the terms of the FreeType project license,
# LICENSE.TXT.  By continuing to use, modify, or distribute this file you
# indicate that you have read the license and understand and accept it
# fully.

#
# Say
#
#   meson configure
#
# to see all configuration options and their default values.  For example,
# to build only a shared version of FreeType, override the default value
# with
#
#   meson setup -Ddefault_library=shared
#

project('freetype2', 'c',
  meson_version: '>= 0.55.0',
  version: run_command('builds/meson/extract_freetype_version.py',
                       'include/freetype/freetype.h',
                       check: true).stdout().strip(),
)


# Only meson >= 0.57 can read a file and assign its contents to a
# variable; we thus use an external command to have this functionality
# with older versions, too.

python_exe = find_program('python3')

ft2_so_version = run_command(python_exe,
  files('builds/meson/extract_libtool_version.py'),
  '--soversion',
  files('builds/unix/configure.raw'),
  check: true).stdout().strip()

ft2_pkgconfig_version = run_command(python_exe,
  files('builds/meson/extract_libtool_version.py'),
  files('builds/unix/configure.raw'),
  check: true).stdout().strip()

ft2_includes = include_directories('include')

freetype_includedir = join_paths(get_option('includedir'), 'freetype2')

ft2_defines = []

freetype_aclocaldir = join_paths(get_option('datadir'), 'aclocal')


# Generate a custom `ftmodule.h` version based on the content of
# `modules.cfg`.

ftmodule_h = custom_target('ftmodule.h',
  output: 'ftmodule.h',
  input: 'modules.cfg',
  command: [python_exe, files('builds/meson/parse_modules_cfg.py'),
            '--format=ftmodule.h', '@INPUT@', '--output', '@OUTPUT@'],
  install: true,
  install_dir: join_paths(freetype_includedir, 'freetype/config'),
)
ft2_sources = [ftmodule_h]
ft2_defines += ['-DFT_CONFIG_MODULES_H=<ftmodule.h>']


# FreeType 2 modules.

ft_main_modules = run_command(python_exe,
  files('builds/meson/parse_modules_cfg.py'),
  '--format=main-modules',
  files('modules.cfg'),
  check: true).stdout().strip().split()

ft2_sources += files([
  'src/base/ftbase.c',
  'src/base/ftinit.c',
])

foreach mod: ft_main_modules
  source = mod
  if mod == 'winfonts'
    source = 'winfnt'
  elif mod == 'cid'
    source = 'type1cid'
  endif
  ft2_sources += 'src/@0@/@1@.c'.format(mod, source)
endforeach

# NOTE: The `bzip2` aux module is handled through options.
ft_aux_modules = run_command(python_exe,
  files('builds/meson/parse_modules_cfg.py'),
  '--format=aux-modules',
  files('modules.cfg'),
  check: true).stdout().strip().split()

foreach auxmod: ft_aux_modules
  source = auxmod
  # Most sources are named `src/<module>/<module>.c`, but there are a few
  # exceptions handled here.
  if auxmod == 'cache'
    source = 'ftcache'
  elif auxmod == 'lzw'
    source = 'ftlzw'
  elif auxmod == 'gzip'
    source = 'ftgzip'
  elif auxmod == 'bzip2'
    # Handled through options instead, see below.
    continue
  endif
  ft2_sources += 'src/@0@/@1@.c'.format(auxmod, source)
endforeach


# FreeType 2 base extensions.
# To be configured in `modules.cfg`.

base_extensions = run_command(python_exe,
  files('builds/meson/parse_modules_cfg.py'),
  '--format=base-extensions-list',
  files('modules.cfg'),
  check: true).stdout().split()

foreach ext: base_extensions
  ft2_sources += files('src/base/' + ext)
endforeach


# Header files.

ft2_public_headers = files([
  'include/freetype/freetype.h',
  'include/freetype/ftadvanc.h',
  'include/freetype/ftbbox.h',
  'include/freetype/ftbdf.h',
  'include/freetype/ftbitmap.h',
  'include/freetype/ftbzip2.h',
  'include/freetype/ftcache.h',
  'include/freetype/ftchapters.h',
  'include/freetype/ftcid.h',
  'include/freetype/ftcolor.h',
  'include/freetype/ftdriver.h',
  'include/freetype/fterrdef.h',
  'include/freetype/fterrors.h',
  'include/freetype/ftfntfmt.h',
  'include/freetype/ftgasp.h',
  'include/freetype/ftglyph.h',
  'include/freetype/ftgxval.h',
  'include/freetype/ftgzip.h',
  'include/freetype/ftimage.h',
  'include/freetype/ftincrem.h',
  'include/freetype/ftlcdfil.h',
  'include/freetype/ftlist.h',
  'include/freetype/ftlogging.h',
  'include/freetype/ftlzw.h',
  'include/freetype/ftmac.h',
  'include/freetype/ftmm.h',
  'include/freetype/ftmodapi.h',
  'include/freetype/ftmoderr.h',
  'include/freetype/ftotval.h',
  'include/freetype/ftoutln.h',
  'include/freetype/ftparams.h',
  'include/freetype/ftpfr.h',
  'include/freetype/ftrender.h',
  'include/freetype/ftsizes.h',
  'include/freetype/ftsnames.h',
  'include/freetype/ftstroke.h',
  'include/freetype/ftsynth.h',
  'include/freetype/ftsystem.h',
  'include/freetype/fttrigon.h',
  'include/freetype/fttypes.h',
  'include/freetype/ftwinfnt.h',
  'include/freetype/otsvg.h',
  'include/freetype/t1tables.h',
  'include/freetype/ttnameid.h',
  'include/freetype/tttables.h',
  'include/freetype/tttags.h',
])

ft2_config_headers = files([
  'include/freetype/config/ftconfig.h',
  'include/freetype/config/ftheader.h',
  'include/freetype/config/ftstdlib.h',
  'include/freetype/config/integer-types.h',
  'include/freetype/config/mac-support.h',
  'include/freetype/config/public-macros.h',
])

ft2_defines += ['-DFT2_BUILD_LIBRARY=1']


# System support file.

cc = meson.get_compiler('c')

# NOTE: msys2 on Windows has `unistd.h` and `fcntl.h` but not `sys/mman.h`!
has_unistd_h = cc.has_header('unistd.h')
has_fcntl_h = cc.has_header('fcntl.h')
has_sys_mman_h = cc.has_header('sys/mman.h')

mmap_option = get_option('mmap')

use_unix_ftsystem_c = false
if mmap_option.disabled()
  ft2_sources += files(['src/base/ftsystem.c',])
elif host_machine.system() == 'windows'
  ft2_sources += files(['builds/windows/ftsystem.c',])
else
  if has_unistd_h and has_fcntl_h and has_sys_mman_h
    # This version of `ftsystem.c` uses `mmap` to read input font files.
    ft2_sources += files(['builds/unix/ftsystem.c',])
    use_unix_ftsystem_c = true
  elif mmap_option.enabled()
    error('mmap was enabled via options but is not available,'
          + ' required headers were not found!')
  else
    ft2_sources += files(['src/base/ftsystem.c',])
  endif
endif


# Debug support file
#
# NOTE: Some specialized versions exist for other platforms not supported by
# Meson.  Most implementation differences are extremely minor, i.e., in the
# implementation of `FT_Message` and `FT_Panic`, and getting the `FT2_DEBUG`
# value from the environment, when this is supported.  A smaller refactor
# might make these platform-specific files much smaller, and could be moved
# into `ftsystem.c` as well.

if host_machine.system() == 'windows'
  winmod = import('windows')
  ft2_sources += [
    'builds/windows/ftdebug.c',
    winmod.compile_resources('src/base/ftver.rc'),
  ]
else
  ft2_sources += 'src/base/ftdebug.c'
endif


ft2_deps = []
common_ldflags = []


# Correct compatibility version for OS x.
#
# OSX sets the compatibility_version (aka libtools version) differently from
# the library name.

if host_machine.system() == 'darwin'
  # maintain compatibility with autotools on macOS
  common_ldflags = [
    '-compatibility_version', ft2_pkgconfig_version.split('.')[0],
    '-current_version', ft2_pkgconfig_version
  ]
endif


# Generate `ftoption.h` based on available dependencies.

process_header_command = [python_exe,
  files('builds/meson/process_ftoption_h.py'),
  '@INPUT@', '--output=@OUTPUT@']

ftoption_command = process_header_command

# External GZip support.
zlib_option = get_option('zlib')

# Backward-compatible aliases.
if zlib_option == 'disabled'
  zlib_option = 'none'
elif zlib_option == 'enabled'
  zlib_option = 'auto'
endif

if zlib_option == 'auto'
  # First try to find a system installation, otherwise fall back to
  # the subproject.
  zlib_dep = dependency('zlib',
    required: false)
  if zlib_dep.found()
    zlib_option = 'system'
  else
    zlib_option = 'external'
  endif
endif

if zlib_option == 'none'
  ftoption_command += [ '--disable=FT_CONFIG_OPTION_USE_ZLIB' ]
elif zlib_option == 'internal'
  ftoption_command += [ '--enable=FT_CONFIG_OPTION_USE_ZLIB' ]
elif zlib_option == 'external'
  ftoption_command += [ '--enable=FT_CONFIG_OPTION_USE_ZLIB' ]
  zlib_project = subproject('zlib',
    required: true,
    default_options: 'default_library=static')
  zlib_dep = zlib_project.get_variable('zlib_dep')
  ft2_deps += [zlib_dep]
elif zlib_option == 'system'
  zlib_dep = dependency('zlib',
    required: true)
  assert(zlib_dep.found(), 'Could not find system zlib installation!')
  ftoption_command += [
    '--enable=FT_CONFIG_OPTION_USE_ZLIB',
    '--enable=FT_CONFIG_OPTION_SYSTEM_ZLIB',
  ]
  ft2_deps += [zlib_dep]
else
  assert(false, 'Invalid zlib option ' + zlib_option)
endif

# BZip2 support.
bzip2_dep = dependency(
  'bzip2',
  required: get_option('bzip2').disabled() ? get_option('bzip2') : false,
)
if not bzip2_dep.found()
  bzip2_dep = cc.find_library(
    'bz2',
    has_headers: ['bzlib.h'],
    required: get_option('bzip2'),
  )
endif

if bzip2_dep.found()
  ftoption_command += ['--enable=FT_CONFIG_OPTION_USE_BZIP2']
  ft2_sources += files(['src/bzip2/ftbzip2.c',])
  ft2_deps += [bzip2_dep]
endif

# PNG support.
libpng_dep = dependency('libpng',
  required: get_option('png'),
  fallback: 'libpng')

if libpng_dep.found()
  ftoption_command += ['--enable=FT_CONFIG_OPTION_USE_PNG']
  ft2_deps += [libpng_dep]
endif

# HarfBuzz support.
harfbuzz_opt = get_option('harfbuzz')
harfbuzz_dep = disabler()

if harfbuzz_opt == 'enabled' or harfbuzz_opt == 'auto'
  harfbuzz_dep = dependency('harfbuzz',
    version: '>= 2.0.0',
    required: harfbuzz_opt == 'enabled',
    default_options: ['freetype=disabled'])
  if harfbuzz_dep.found()
    harfbuzz_opt = 'YES'
    ftoption_command += ['--enable=FT_CONFIG_OPTION_USE_HARFBUZZ']
    ft2_deps += [harfbuzz_dep]
  endif
endif

if not harfbuzz_dep.found() and \
   (harfbuzz_opt == 'dynamic' or harfbuzz_opt == 'auto')
  # On Windows we don't need libdl, but on other platforms we need it.
  if host_machine.system() == 'windows'
    harfbuzz_opt = 'dynamic'
    ftoption_command += [
      '--enable=FT_CONFIG_OPTION_USE_HARFBUZZ',
      '--enable=FT_CONFIG_OPTION_USE_HARFBUZZ_DYNAMIC',
    ]
  else
    harfbuzz_dep = meson.get_compiler('c').find_library('dl',
      required: harfbuzz_opt == 'dynamic',
    )
    if harfbuzz_dep.found()
      harfbuzz_opt = 'dynamic'
      ftoption_command += [
        '--enable=FT_CONFIG_OPTION_USE_HARFBUZZ',
        '--enable=FT_CONFIG_OPTION_USE_HARFBUZZ_DYNAMIC',
      ]
      ft2_deps += [harfbuzz_dep]
    endif
  endif
endif

if harfbuzz_opt == 'disabled' or harfbuzz_opt == 'auto'
  harfbuzz_opt = 'NO'
endif

# Brotli decompression support.
brotli_dep = dependency('libbrotlidec',
  required: get_option('brotli'))

if brotli_dep.found()
  ftoption_command += ['--enable=FT_CONFIG_OPTION_USE_BROTLI']
  ft2_deps += [brotli_dep]
endif

if get_option('error_strings')
  ftoption_command += ['--enable=FT_CONFIG_OPTION_ERROR_STRINGS']
endif

# We can now generate `ftoption.h`.
ftoption_h = custom_target('ftoption.h',
  input: 'include/freetype/config/ftoption.h',
  output: 'ftoption.h',
  command: ftoption_command,
  install: true,
  install_dir: join_paths(freetype_includedir, 'freetype/config'),
)
ft2_sources += ftoption_h
ft2_defines += ['-DFT_CONFIG_OPTIONS_H=<ftoption.h>']

if host_machine.system() == 'windows' and \
   get_option('default_library') == 'shared'
  ft2_defines += ['-DDLL_EXPORT=1']
endif


# Generate `ftconfig.h`.

ftconfig_command = process_header_command

if has_unistd_h
  ftconfig_command += '--enable=HAVE_UNISTD_H'
endif
if has_fcntl_h
  ftconfig_command += '--enable=HAVE_FCNTL_H'
endif

if use_unix_ftsystem_c
  ftconfig_h_in = files('builds/unix/ftconfig.h.in')
  ftconfig_h = custom_target('ftconfig.h',
    input: ftconfig_h_in,
    output: 'ftconfig.h',
    command: ftconfig_command,
    install: true,
    install_dir: join_paths(freetype_includedir, 'freetype/config'),
  )
  ft2_sources += ftconfig_h
  ft2_defines += ['-DFT_CONFIG_CONFIG_H=<ftconfig.h>']
endif


ft2_lib = library('freetype',
  sources: ft2_sources + [ftmodule_h],
  c_args: ft2_defines,
  gnu_symbol_visibility: 'hidden',
  include_directories: ft2_includes,
  dependencies: ft2_deps,
  install: true,
  version: ft2_so_version,
  link_args: common_ldflags,
)


# To be used by other projects including this one via `subproject`.

freetype_dep = declare_dependency(
  include_directories: ft2_includes,
  link_with: ft2_lib,
  version: ft2_pkgconfig_version)

meson.override_dependency('freetype2', freetype_dep)


# NOTE: Using both `install_dir` and `subdir` doesn't seem to work
# below, i.e., the `subdir` value seems to be ignored, contrary to
# examples in the Meson documentation.
install_headers('include/ft2build.h',
  install_dir: freetype_includedir)
install_headers(ft2_public_headers,
  install_dir: join_paths(freetype_includedir, 'freetype'))
install_headers(ft2_config_headers,
  install_dir: join_paths(freetype_includedir, 'freetype/config'))


install_data('builds/unix/freetype2.m4',
  install_dir: freetype_aclocaldir)


pkgconfig = import('pkgconfig')

pkgconfig.generate(ft2_lib,
  filebase: 'freetype2',
  name: 'FreeType 2',
  description: 'A free, high-quality, and portable font engine.',
  url: 'https://freetype.org',
  subdirs: 'freetype2',
  version: ft2_pkgconfig_version,
)

if get_option('tests').enabled()
  subdir('tests')
endif


# NOTE: Unlike the old `make refdoc` command, this generates the
# documentation under `$BUILD/docs/` since Meson doesn't support modifying
# the source root directory (which is a good thing).

gen_docs = custom_target('freetype2 reference documentation',
  output: 'docs',
  input: ft2_public_headers + ft2_config_headers,
  command: [python_exe,
    files('builds/meson/generate_reference_docs.py'),
    '--version=' + meson.project_version(),
    '--input-dir=' + meson.current_source_dir(),
    '--output-dir=@OUTPUT@'
  ],
)


summary({'OS': host_machine.system(),
        }, section: 'Operating System')

summary({'Zlib': zlib_option,
         'Bzip2': bzip2_dep.found(),
         'Png': libpng_dep.found(),
         'HarfBuzz': harfbuzz_opt,
         'Brotli': brotli_dep.found(),
        }, bool_yn: true, section: 'Used Libraries')

# EOF
