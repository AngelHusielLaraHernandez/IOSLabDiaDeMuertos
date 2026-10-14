#!/usr/bin/env python3
"""Crea una configuración local de Xcode sin copiar el código compartido."""
import argparse
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
NAME = 'OfrendaDiaDeMuertosProyecto'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--ios-minimo', default='26.2', help='iOS mínimo para esta Mac; por defecto 26.2')
args = parser.parse_args()
if not re.fullmatch(r'\d+\.\d+(?:\.\d+)?', args.ios_minimo):
    parser.error('Usa una versión como 26.2 o 26.4.')
project = ROOT / 'ProyectoLocal' / (NAME + '.xcodeproj')
if project.exists():
    if not (project / 'project.pbxproj').is_file():
        sys.exit('La carpeta local ya existe pero no contiene un proyecto válido. Revísala sin borrarla.')
    print('Se conserva tu proyecto local existente; no se sobrescribieron sus ajustes.')
    print(project)
    sys.exit(0)
relative = project.relative_to(ROOT).as_posix() + '/project.pbxproj'
ignored = subprocess.run(['git', '-C', str(ROOT), 'check-ignore', '--quiet', '--no-index', relative])
if ignored.returncode != 0:
    sys.exit('ProyectoLocal/ debe estar en .gitignore antes de crear el proyecto.')
template = ROOT / (NAME + '.xcodeproj') / 'project.pbxproj'
text = template.read_text()
source = f'path = {NAME};'
if text.count(source) != 1:
    sys.exit('La plantilla cambió: no se encontró una única carpeta de código compartido.')
text = text.replace(source, f'path = "../{NAME}";')
text = re.sub(r'\bobjectVersion = \d+;', 'objectVersion = 77;', text)
text = re.sub(r'\bpreferredProjectObjectVersion = \d+;', 'preferredProjectObjectVersion = 77;', text)
text = re.sub(r'\bIPHONEOS_DEPLOYMENT_TARGET = [^;]+;', f'IPHONEOS_DEPLOYMENT_TARGET = {args.ios_minimo};', text)
project.mkdir(parents=True)
(project / 'project.pbxproj').write_text(text)
workspace = project / 'project.xcworkspace'
workspace.mkdir()
(workspace / 'contents.xcworkspacedata').write_text('<?xml version="1.0" encoding="UTF-8"?>\n<Workspace version="1.0"><FileRef location="self:"></FileRef></Workspace>\n')
print('Proyecto local creado; los Swift y Assets se referencian desde la carpeta compartida.')
print(project)
print('Ábrelo en Xcode. Las siguientes ejecuciones conservarán tus ajustes locales.')
