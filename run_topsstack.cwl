#!/usr/bin/env cwl-runner

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#
baseCommand: [sh]
arguments:
- -c
- cat .netrc && 
  echo "/opt/conda/bin/papermill $(inputs.input_nb) $(inputs.output_nb) -f $(inputs.parameters.path)"
#- if [ ! -d $HOME/topsstack_hamsar ]; then cp -rp /home/jovyan/topsstack_hamsar $HOME/; fi &&
#  /opt/conda/bin/papermill $(inputs.input_nb) $(inputs.output_nb) -f $(inputs.parameters.path)
hints:
  "cwltool:Secrets":
    secrets:
      - urs_user
      - urs_pass
requirements:
  DockerRequirement:
  #  dockerPull: container-xing_topsstack_hamsar:devel
    dockerPull: pymonger/pge-base-conda-python368:20220121
  InitialWorkDirRequirement:
    listing:
      - entryname: .netrc
        entry: |
          machine urs.earthdata.nasa.gov login $(inputs.urs_user) password $(inputs.urs_pass)
          macdef init
  NetworkAccess:
    class: NetworkAccess
    networkAccess: true
inputs:
  urs_user: string
  urs_pass: string
  input_nb: string
  output_nb: string
  parameters:
    type: File
outputs:
  stdout_stream:
    type: stdout
  stderr_stream:
    type: stderr
#  stdout_file:
#    type: stdout
#  stderr_file:
#    type: stderr
#stdout: stdout_run_topsstack.txt
#stderr: stderr_run_topsstack.txt
