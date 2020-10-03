# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

COMMONENVVAR=GOOS=$(shell uname -s | tr A-Z a-z) GOARCH=$(subst x86_64,amd64,$(patsubst i%86,386,$(shell uname -m)))
BUILDENVVAR=CGO_ENABLED=0
# If tag not explicitly set in users default to the git sha.
TAG ?= v0.0.1

.PHONY: all
all: build

.PHONY: build
build: autogen
	$(COMMONENVVAR) $(BUILDENVVAR) go build -ldflags '-w' -o bin/kube-scheduler cmd/main.go

.PHONY: update-vendor
update-vendor:
	hack/update-vendor.sh

.PHONY: unit-test
unit-test: update-vendor
	hack/unit-test.sh

.PHONY: autogen
autogen: update-vendor
	hack/update-generated-openapi.sh

.PHONY: verify-gofmt
verify-gofmt:
	hack/verify-gofmt.sh

.PHONY: image
image: build
	docker build  . -t vincentpli/scheduler-framework-sample:$(TAG)