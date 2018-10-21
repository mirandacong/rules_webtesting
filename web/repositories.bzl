# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Defines external repositories needed by rules_webtesting."""

load("//web/internal:platform_http_file.bzl", "platform_http_file")
load("@bazel_gazelle//:deps.bzl", "go_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:java.bzl", "java_import_external")

# NOTE: URLs are mirrored by an asynchronous review process. They must
#       be greppable for that to happen. It's OK to submit broken mirror
#       URLs, so long as they're correctly formatted. Bazel's downloader
#       has fast failover.

def web_test_repositories(**kwargs):
    """Defines external repositories required by Webtesting Rules.

    This function exists for other Bazel projects to call from their WORKSPACE
    file when depending on rules_webtesting using http_archive. This function
    makes it easy to import these transitive dependencies into the parent
    workspace. This will check to see if a repository has been previously defined
    before defining a new repository.

    Alternatively, individual dependencies may be excluded with an
    "omit_" + name parameter. This is useful for users who want to be rigorous
    about declaring their own direct dependencies, or when another Bazel project
    is depended upon (e.g. rules_closure) that defines the same dependencies as
    this one (e.g. com_google_guava.) Alternatively, a whitelist model may be
    used by calling the individual functions this method references.

    Please note that while these dependencies are defined, they are not actually
    downloaded, unless a target is built that depends on them.

    Args:
        **kwargs: omit_... parameters used to prevent importing specific
          dependencies.
    """
    if should_create_repository("bazel_skylib", kwargs):
        bazel_skylib()
    if should_create_repository("com_github_blang_semver", kwargs):
        com_github_blang_semver()
    if should_create_repository("com_github_gorilla_context", kwargs):
        com_github_gorilla_context()
    if should_create_repository("com_github_gorilla_mux", kwargs):
        com_github_gorilla_mux()
    if should_create_repository("com_github_tebeka_selenium", kwargs):
        com_github_tebeka_selenium()
    if should_create_repository("com_google_code_findbugs_jsr305", kwargs):
        com_google_code_findbugs_jsr305()
    if should_create_repository("com_google_code_gson", kwargs):
        com_google_code_gson()
    if should_create_repository(
        "com_google_errorprone_error_prone_annotations",
        kwargs,
    ):
        com_google_errorprone_error_prone_annotations()
    if should_create_repository("com_google_guava", kwargs):
        com_google_guava()
    if should_create_repository("com_squareup_okhttp3_okhttp", kwargs):
        com_squareup_okhttp3_okhttp()
    if should_create_repository("com_squareup_okio", kwargs):
        com_squareup_okio()
    if should_create_repository("commons_codec", kwargs):
        commons_codec()
    if should_create_repository("commons_logging", kwargs):
        commons_logging()
    if should_create_repository("junit", kwargs):
        junit()
    if should_create_repository("net_bytebuddy", kwargs):
        net_bytebuddy()
    if should_create_repository("org_apache_commons_exec", kwargs):
        org_apache_commons_exec()
    if should_create_repository("org_apache_httpcomponents_httpclient", kwargs):
        org_apache_httpcomponents_httpclient()
    if should_create_repository("org_apache_httpcomponents_httpcore", kwargs):
        org_apache_httpcomponents_httpcore()
    if should_create_repository("org_hamcrest_core", kwargs):
        org_hamcrest_core()
    if should_create_repository("org_json", kwargs):
        org_json()
    if should_create_repository("org_seleniumhq_py", kwargs):
        org_seleniumhq_py()
    if should_create_repository("org_seleniumhq_selenium_api", kwargs):
        org_seleniumhq_selenium_api()
    if should_create_repository("org_seleniumhq_selenium_remote_driver", kwargs):
        org_seleniumhq_selenium_remote_driver()
    if kwargs.keys():
        print("The following parameters are unknown: " + str(kwargs.keys()))

def should_create_repository(name, args):
    """Returns whether the name repository should be created.

    This allows creation of a repository to be disabled by either an
    "omit_" _+ name parameter or by previously defining a rule for the repository.

    The args dict will be mutated to remove "omit_" + name.

    Args:
        name: The name of the repository that should be checked.
        args: A dictionary that contains "omit_...": bool pairs.

    Returns:
        boolean indicating whether the repository should be created.
    """
    key = "omit_" + name
    if key in args:
        val = args.pop(key)
        if val:
            return False
    if native.existing_rule(name):
        return False
    return True

def browser_repositories(firefox = False, chromium = False, sauce = False):
    """Sets up repositories for browsers defined in //browsers/....

    This should only be used on an experimental basis; projects should define
    their own browsers.

    Args:
        firefox: Configure repositories for //browsers:firefox-native.
        chromium: Configure repositories for //browsers:chromium-native.
        sauce: Configure repositories for //browser/sauce:chrome-win10.
    """
    if chromium:
        org_chromium_chromedriver()
        org_chromium_chromium()
    if firefox:
        org_mozilla_firefox()
        org_mozilla_geckodriver()
    if sauce:
        com_saucelabs_sauce_connect()

def bazel_skylib():
    http_archive(
        name = "bazel_skylib",
        sha256 = "b5f6abe419da897b7901f90cbab08af958b97a8f3575b0d3dd062ac7ce78541f",
        strip_prefix = "bazel-skylib-0.5.0",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/archive/0.5.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/archive/0.5.0.tar.gz",
        ],
    )

def com_github_blang_semver():
    go_repository(
        name = "com_github_blang_semver",
        importpath = "github.com/blang/semver",
        sha256 = "3d9da53f4c2d3169bfa9b25f2f36f301a37556a47259c870881524c643c69c57",
        strip_prefix = "semver-3.5.1",
        urls = [
            "https://mirror.bazel.build/github.com/blang/semver/archive/v3.5.1.tar.gz",
            "https://github.com/blang/semver/archive/v3.5.1.tar.gz",
        ],
    )

def com_github_gorilla_context():
    go_repository(
        name = "com_github_gorilla_context",
        importpath = "github.com/gorilla/context",
        sha256 = "12a849b4e9a08619233d4490a281aa2d34a69f9eaf85c2295f5357927e4d1763",
        strip_prefix = "context-1.1",
        urls = [
            "https://mirror.bazel.build/github.com/gorilla/context/archive/v1.1.tar.gz",
            "https://github.com/gorilla/context/archive/v1.1.tar.gz",
        ],
    )

def com_github_gorilla_mux():
    go_repository(
        name = "com_github_gorilla_mux",
        importpath = "github.com/gorilla/mux",
        sha256 = "0dc18fb09413efea7393e9c2bd8b5b442ce08e729058f5f7e328d912c6c3d3e3",
        strip_prefix = "mux-1.6.2",
        urls = [
            "https://mirror.bazel.build/github.com/gorilla/mux/archive/v1.6.2.tar.gz",
            "https://github.com/gorilla/mux/archive/v1.6.2.tar.gz",
        ],
    )

def com_github_tebeka_selenium():
    go_repository(
        name = "com_github_tebeka_selenium",
        importpath = "github.com/tebeka/selenium",
        sha256 = "c506637fd690f4125136233a3ea405908b8255e2d7aa2aa9d3b746d96df50dcd",
        strip_prefix = "selenium-a49cf4b98a36c2b21b1ccb012852bd142d5fc04a",
        urls = [
            "https://mirror.bazel.build/github.com/tebeka/selenium/archive/a49cf4b98a36c2b21b1ccb012852bd142d5fc04a.tar.gz",
            "https://github.com/tebeka/selenium/archive/a49cf4b98a36c2b21b1ccb012852bd142d5fc04a.tar.gz",
        ],
    )

def com_google_code_findbugs_jsr305():
    java_import_external(
        name = "com_google_code_findbugs_jsr305",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar",
            "https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar",
        ],
        jar_sha256 =
            "766ad2a0783f2687962c8ad74ceecc38a28b9f72a2d085ee438b7813e928d0c7",
        licenses = ["notice"],  # BSD 3-clause
    )

def com_google_code_gson():
    java_import_external(
        name = "com_google_code_gson",
        jar_sha256 =
            "233a0149fc365c9f6edbd683cfe266b19bdc773be98eabdaf6b3c924b48e7d81",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/com/google/code/gson/gson/2.8.5/gson-2.8.5.jar",
            "https://repo1.maven.org/maven2/com/google/code/gson/gson/2.8.5/gson-2.8.5.jar",
        ],
        licenses = ["notice"],  # The Apache Software License, Version 2.0
    )

def com_google_errorprone_error_prone_annotations():
    java_import_external(
        name = "com_google_errorprone_error_prone_annotations",
        jar_sha256 =
            "10a5949aa0f95c8de4fd47edfe20534d2acefd8c224f8afea1f607e112816120",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/2.3.1/error_prone_annotations-2.3.1.jar",
            "https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/2.3.1/error_prone_annotations-2.3.1.jar",
        ],
        licenses = ["notice"],  # Apache 2.0
    )

def com_google_guava():
    java_import_external(
        name = "com_google_guava",
        jar_sha256 =
            "6db0c3a244c397429c2e362ea2837c3622d5b68bb95105d37c21c36e5bc70abf",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/com/google/guava/guava/25.1-jre/guava-25.1-jre.jar",
            "https://repo1.maven.org/maven2/com/google/guava/guava/25.1-jre/guava-25.1-jre.jar",
        ],
        licenses = ["notice"],  # Apache 2.0
        exports = [
            "@com_google_code_findbugs_jsr305",
            "@com_google_errorprone_error_prone_annotations",
        ],
    )

def com_saucelabs_sauce_connect():
    platform_http_file(
        name = "com_saucelabs_sauce_connect",
        licenses = ["by_exception_only"],  # SauceLabs EULA
        amd64_sha256 =
            "dc47e3b42206f7ac073a06df168395eba215fdafef4f0e1b3c02c7b788e91bfb",
        amd64_urls = [
            "https://saucelabs.com/downloads/sc-4.4.12-linux.tar.gz",
        ],
        macos_sha256 =
            "624f27fcef2b7797ab1b26d6149cc7559f40305e761ac4c6844c59e3125f1abf",
        macos_urls = [
            "https://saucelabs.com/downloads/sc-4.4.12-osx.zip",
        ],
        windows_sha256 =
            "ec11b4ee029c9f0cba316820995df6ab5a4f394053102e1871b9f9589d0a9eb5",
        windows_urls = [
            "https://saucelabs.com/downloads/sc-4.4.12-win32.zip",
        ],
    )

def com_squareup_okhttp3_okhttp():
    java_import_external(
        name = "com_squareup_okhttp3_okhttp",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/com/squareup/okhttp3/okhttp/3.9.1/okhttp-3.9.1.jar",
            "https://repo1.maven.org/maven2/com/squareup/okhttp3/okhttp/3.9.1/okhttp-3.9.1.jar",
        ],
        jar_sha256 =
            "a0d01017a42bba26e507fc6d448bb36e536f4b6e612f7c42de30bbdac2b7785e",
        licenses = ["notice"],  # Apache 2.0
        deps = [
            "@com_squareup_okio",
            "@com_google_code_findbugs_jsr305",
        ],
    )

def com_squareup_okio():
    java_import_external(
        name = "com_squareup_okio",
        jar_sha256 =
            "693fa319a7e8843300602b204023b7674f106ebcb577f2dd5807212b66118bd2",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/com/squareup/okio/okio/1.15.0/okio-1.15.0.jar",
            "https://repo1.maven.org/maven2/com/squareup/okio/okio/1.15.0/okio-1.15.0.jar",
        ],
        licenses = ["notice"],  # Apache 2.0
        deps = ["@com_google_code_findbugs_jsr305"],
    )

def commons_codec():
    java_import_external(
        name = "commons_codec",
        jar_sha256 =
            "e599d5318e97aa48f42136a2927e6dfa4e8881dff0e6c8e3109ddbbff51d7b7d",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/commons-codec/commons-codec/1.11/commons-codec-1.11.jar",
            "https://repo1.maven.org/maven2/commons-codec/commons-codec/1.11/commons-codec-1.11.jar",
        ],
        licenses = ["notice"],  # Apache License, Version 2.0
    )

def commons_logging():
    java_import_external(
        name = "commons_logging",
        jar_sha256 =
            "daddea1ea0be0f56978ab3006b8ac92834afeefbd9b7e4e6316fca57df0fa636",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar",
            "https://repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar",
        ],
        licenses = ["notice"],  # The Apache Software License, Version 2.0
    )

def junit():
    java_import_external(
        name = "junit",
        jar_sha256 =
            "59721f0805e223d84b90677887d9ff567dc534d7c502ca903c0c2b17f05c116a",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/junit/junit/4.12/junit-4.12.jar",
            "https://repo1.maven.org/maven2/junit/junit/4.12/junit-4.12.jar",
        ],
        licenses = ["reciprocal"],  # Eclipse Public License 1.0
        testonly_ = 1,
        deps = ["@org_hamcrest_core"],
    )

def net_bytebuddy():
    java_import_external(
        name = "net_bytebuddy",
        jar_sha256 =
            "35c47d53ec21f6b3bff018b07306c35d8b078b11642a610699f6718f75157e52",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/net/bytebuddy/byte-buddy/1.8.9/byte-buddy-1.8.9.jar",
            "https://repo1.maven.org/maven2/net/bytebuddy/byte-buddy/1.8.9/byte-buddy-1.8.9.jar",
        ],
        licenses = ["notice"],  # Apache 2.0
    )

def org_apache_commons_exec():
    java_import_external(
        name = "org_apache_commons_exec",
        jar_sha256 =
            "cb49812dc1bfb0ea4f20f398bcae1a88c6406e213e67f7524fb10d4f8ad9347b",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/org/apache/commons/commons-exec/1.3/commons-exec-1.3.jar",
            "https://repo1.maven.org/maven2/org/apache/commons/commons-exec/1.3/commons-exec-1.3.jar",
        ],
        licenses = ["notice"],  # Apache License, Version 2.0
    )

def org_apache_httpcomponents_httpclient():
    java_import_external(
        name = "org_apache_httpcomponents_httpclient",
        jar_sha256 =
            "c03f813195e7a80e3608d0ddd8da80b21696a4c92a6a2298865bf149071551c7",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.6/httpclient-4.5.6.jar",
            "https://repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.6/httpclient-4.5.6.jar",
        ],
        licenses = ["notice"],  # Apache License, Version 2.0
        deps = [
            "@org_apache_httpcomponents_httpcore",
            "@commons_logging",
            "@commons_codec",
        ],
    )

def org_apache_httpcomponents_httpcore():
    java_import_external(
        name = "org_apache_httpcomponents_httpcore",
        jar_sha256 =
            "1b4a1c0b9b4222eda70108d3c6e2befd4a6be3d9f78ff53dd7a94966fdf51fc5",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.9/httpcore-4.4.9.jar",
            "https://repo1.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.9/httpcore-4.4.9.jar",
        ],
        licenses = ["notice"],  # Apache License, Version 2.0
    )

def org_chromium_chromedriver():
    platform_http_file(
        name = "org_chromium_chromedriver",
        licenses = ["reciprocal"],  # BSD 3-clause, ICU, MPL 1.1, libpng (BSD/MIT-like), Academic Free License v. 2.0, BSD 2-clause, MIT
        amd64_sha256 =
            "2ad85db0d73e642af4698ed889977784640445e873ceb956f7a364fa824c631d",
        amd64_urls = [
            "http://mirrors.corp.logiocean.com/file-store/chromedriver/chromedriver_linux64.zip",
            "https://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip",
        ],
        macos_sha256 =
            "3a5e47d7530923268e6ade36eb4647b6a327fc48c7a54e72d7ea67791a0cae29",
        macos_urls = [
            "https://chromedriver.storage.googleapis.com/2.40/chromedriver_mac64.zip",
        ],
        windows_sha256 =
            "035e7cac5dcf1eed73f3c9d0594fe1cd3c7b578670b4e7f2cadb5b3f6d48eaf2",
        windows_urls = [
            "https://chromedriver.storage.googleapis.com/2.40/chromedriver_win32.zip",
        ],
    )

def org_chromium_chromium():
    platform_http_file(
        name = "org_chromium_chromium",
        licenses = ["notice"],  # BSD 3-clause (maybe more?)
        amd64_sha256 =
            "665f3ec731ea93ca4d4593cd9ab7095634dd89b7e332d92bb7722f3f1a59e0f7",
        amd64_urls = [
            "http://mirrors.corp.logiocean.com/file-store/chromium-browser-snapshots/chrome-linux.zip",
            "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/573780/chrome-linux.zip",
        ],
        macos_sha256 =
            "029e4647ea579c0df38e770bd47a5c229723580b7c655fcf2bffb909dfb19e29",
        macos_urls = [
            "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/573760/chrome-mac.zip",
        ],
        windows_sha256 =
            "59d1464c11c1d84d3c8941fe1a3a828771382c997b57be1039d8cdc0911f3ce2",
        windows_urls = [
            "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Win_x64/573768/chrome-win32.zip",
        ],
    )

def org_hamcrest_core():
    java_import_external(
        name = "org_hamcrest_core",
        jar_sha256 =
            "66fdef91e9739348df7a096aa384a5685f4e875584cce89386a7a47251c4d8e9",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar",
            "https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar",
        ],
        licenses = ["notice"],  # New BSD License
        testonly_ = 1,
    )

def org_json():
    java_import_external(
        name = "org_json",
        jar_sha256 =
            "3eddf6d9d50e770650e62abe62885f4393aa911430ecde73ebafb1ffd2cfad16",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/org/json/json/20180130/json-20180130.jar",
            "https://repo1.maven.org/maven2/org/json/json/20180130/json-20180130.jar",
        ],
        licenses = ["notice"],  # MIT-style license
    )

def org_mozilla_firefox():
    platform_http_file(
        name = "org_mozilla_firefox",
        licenses = ["reciprocal"],  # MPL 2.0
        amd64_sha256 =
            "134fec04819eb56fa7b644cdd6d89623b21f4020bbedc3bd122db2a2caa4e434",
        amd64_urls = [
            "http://ns1.corp.logiocean.com/file-store/firefox/firefox-58.0.tar.bz2",
            "https://mirror.bazel.build/ftp.mozilla.org/pub/firefox/releases/58.0/linux-x86_64/en-US/firefox-58.0.tar.bz2",
            "https://ftp.mozilla.org/pub/firefox/releases/58.0/linux-x86_64/en-US/firefox-58.0.tar.bz2",
        ],
        macos_sha256 =
            "a853eb20821a21c0bedeb0263d7b5975e7704f20b78edfef129c73804b1fb962",
        macos_urls = [
            "https://mirror.bazel.build/ftp.mozilla.org/pub/firefox/releases/58.0/mac/en-US/Firefox%2058.0.dmg",
            "https://ftp.mozilla.org/pub/firefox/releases/58.0/mac/en-US/Firefox%2058.0.dmg",
        ],
    )

def org_mozilla_geckodriver():
    platform_http_file(
        name = "org_mozilla_geckodriver",
        licenses = ["reciprocal"],  # MPL 2.0
        amd64_sha256 =
            "7f55c4c89695fd1e6f8fc7372345acc1e2dbaa4a8003cee4bd282eed88145937",
        amd64_urls = [
            "http://ns1.corp.logiocean.com/file-store/geckodriver/geckodriver-v0.19.1-linux64.tar.gz",
            "https://mirror.bazel.build/github.com/mozilla/geckodriver/releases/download/v0.19.1/geckodriver-v0.19.1-linux64.tar.gz",
            "https://github.com/mozilla/geckodriver/releases/download/v0.19.1/geckodriver-v0.19.1-linux64.tar.gz",
        ],
        macos_sha256 =
            "eb5a2971e5eb4a2fe74a3b8089f0f2cc96eed548c28526b8351f0f459c080836",
        macos_urls = [
            # TODO(fisherii): v0.19.1 is mirrored and ready to go.
            "https://mirror.bazel.build/github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-macos.tar.gz",
            "https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-macos.tar.gz",
        ],
    )

def org_seleniumhq_py():
    http_archive(
        name = "org_seleniumhq_py",
        build_file = str(Label("//build_files:org_seleniumhq_py.BUILD")),
        sha256 = "f35bb209cab740c195276a323c1b750dbcfdb9f6983e7d6e3abba9cd8838f355",
        strip_prefix = "selenium-3.13.0",
        urls = [
            "https://files.pythonhosted.org/packages/6d/4b/30b28589f2b6051b04d6f8014537749dc08fa787a5569cebb33e892d34d3/selenium-3.13.0.tar.gz",
        ],
    )

def org_seleniumhq_selenium_api():
    java_import_external(
        name = "org_seleniumhq_selenium_api",
        jar_sha256 =
            "2aa536043b519c5e9d9eb8de387d40f17a707e53eebad27d243f641043fa7df0",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/org/seleniumhq/selenium/selenium-api/3.13.0/selenium-api-3.13.0.jar",
            "https://repo1.maven.org/maven2/org/seleniumhq/selenium/selenium-api/3.13.0/selenium-api-3.13.0.jar",
        ],
        licenses = ["notice"],  # The Apache Software License, Version 2.0
        testonly_ = 1,
    )

def org_seleniumhq_selenium_remote_driver():
    java_import_external(
        name = "org_seleniumhq_selenium_remote_driver",
        jar_sha256 =
            "f0d4acd03221bea01471b7171acbc1c97d18e8deb6bbb7c5102bc3712c234fa2",
        jar_urls = [
            "https://mirror.bazel.build/repo1.maven.org/maven2/org/seleniumhq/selenium/selenium-remote-driver/3.13.0/selenium-remote-driver-3.13.0.jar",
            "https://repo1.maven.org/maven2/org/seleniumhq/selenium/selenium-remote-driver/3.13.0/selenium-remote-driver-3.13.0.jar",
        ],
        licenses = ["notice"],  # The Apache Software License, Version 2.0
        testonly_ = 1,
        deps = [
            "@com_google_code_gson",
            "@com_google_guava",
            "@net_bytebuddy",
            "@com_squareup_okhttp3_okhttp",
            "@com_squareup_okio",
            "@commons_codec",
            "@commons_logging",
            "@org_apache_commons_exec",
            "@org_apache_httpcomponents_httpclient",
            "@org_apache_httpcomponents_httpcore",
            "@org_seleniumhq_selenium_api",
        ],
    )
