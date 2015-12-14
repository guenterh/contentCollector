#!/bin/sh

DATA_BASE_DIR=/swissbib/harvesting/sboaitest
CONTENTENV_HOME=/home/harvester/envContentCollector
VIRTUAL_PYTHON_ENV=${CONTENTENV_HOME}/env
PROCESS_DIR=${CONTENTENV_HOME}/bintest
RUNDIR=${DATA_BASE_DIR}/rundir
CONFDIR=${CONTENTENV_HOME}/confdirtest


#echo $CONFDIR
#echo $RUNDIR
#echo $PROCESS_DIR
#echo $VIRTUAL_PYTHON_ENV
#echo $CONTENTENV_HOME
#echo $DATA_BASE_DIR


#Benutze die Default Repos nicht auf dem Alternativ-host fuer Harvesting
#dieser wird fuer GND, DSV11 und Soezialfälle eingesetzt
#DEFAULTREPOS="libib serval ecod snl sbt idsbb idslu idssg1 idssg2 POSTERS zora retroseals abn bgr sgbn"
DEFAULTREPOS=""


if [ -n "$1" ]; then
  repos=$*
  repo_force=1
else
  repos=${DEFAULTREPOS}
  repo_force=0
fi

for repo in ${repos}; do
  LOCKFILE=${CONFDIR}/${repo}.lock

  if [ -e ${LOCKFILE} ]; then
    echo -n "${repo} is locked, probably by another harvester: "
    cat ${LOCKFILE}
    continue
  else
    echo $$ >${LOCKFILE}
  fi

  CONFIG=${CONFDIR}/config.${repo}.prod.xml
  #echo $CONFIG
  #echo ${VIRTUAL_PYTHON_ENV}/bin/python
  #echo ${PROCESS_DIR}/swissbibHarvesting.py

  ${VIRTUAL_PYTHON_ENV}/bin/python  ${PROCESS_DIR}/swissbibHarvesting.py --config=${CONFIG} >> ${RUNDIR}/process-harvesting-python.log 2>&1
  #${VIRTUAL_PYTHON_ENV}/bin/python  ${PROCESS_DIR}/swissbibHarvesting.py --config=${CONFIG} 

  rm ${LOCKFILE}


done

