#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /CoreOS/tang-operator/Sanity
#   Description: Basic functionality tests of the tang operator
#   Author: Patrik Koncity <pkoncity@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2024 Red Hat, Inc.
#
#   This program is free software: you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation, either version 2 of
#   the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE.  See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see http://www.gnu.org/licenses/.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Include Beaker environment
. /usr/share/beakerlib/beakerlib.sh || exit 1

rlJournalStart
    rlPhaseStartTest
        SRC_RPM_DIR="llhttp_src_rpm"
        TEST_SRC_DIR="src_files"
        rlRun "mkdir $SRC_RPM_DIR"
        rlRun "mkdir $TEST_SRC_DIR"
        rlRun "dnf download --source llhttp"
        # Extract the source code from the SRPM do DIR
        rlRun "rpm2cpio llhttp-* | (pushd $SRC_RPM_DIR && cpio -idmv)"
        # Navigate to the extracted source code directory
        rlRun "tar -xzvf $SRC_RPM_DIR/llhttp*.*.tar.gz -C $TEST_SRC_DIR"
        #rlRun "git clone https://github.com/nodejs/llhttp.git"
        pushd $TEST_SRC_DIR/llhttp-*.*
        rlRun "npm ci --ignore-scripts"
        rlRun -s "npm test"
        #llhttp HTTP request smuggling subtest
        rlAssertGrep 'request-lenient-headers' $rlRun_LOG
        popd
        #just upstream testing
        #rlRun "git clone https://github.com/nodejs/llhttp.git"
        #pushd llhttp
        #rlRun "npm ci --ignore-scripts"
        #rlRun -s "npm test"
        #rlAssertGrep 'request-lenient-headers' $rlRun_LOG
        #popd
    rlPhaseEnd
rlJournalEnd
