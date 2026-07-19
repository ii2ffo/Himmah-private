#!/usr/bin/env bash
set -e
flutter create --platforms=android,ios --org com.himmah --project-name himmah .
flutter pub get
