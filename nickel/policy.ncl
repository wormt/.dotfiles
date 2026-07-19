# Nickel is kool. In this file, key_dirs and host_insecure(optional) are input.
# The default type is a reject policy. Then, all of the transports are evaluated
# by first getting transport_defaults (which is very straightforward).
# Ideally I want transport_defaults to include all policy types, but if i need
# custom functionality for one I'll have to remove it from transport_defaults.
# I'm too lazy to implement that. The defaults are then merged with the base_docker
# function(which takes key dir input, which lets it only be half hardcoded) and
# the insecure host overrides. Base docker function does a left fold over every
# registry inside of it. https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.fold

# todo: make base os keep every pki in the same directory, even if just linked
# above may not be a good idea though.

# todo: transport_defaults 3 way merges in the future would be cool
let mk_registries = fun entries =>
  std.array.fold_left
    (fun acc entry => std.record.insert entry.registry entry.policy acc
    )
    {}
    entries
in

let base_docker = fun inputs =>
  mk_registries [
    {
      registry = "ghcr.io/secureblue",
      policy = [
        {
          type = "sigstoreSigned",
          keyPaths = [
            "%{inputs.keys_dir}/containers/secureblue.pub",
            "%{inputs.keys_dir}/containers/secureblue-2025.pub",
          ],
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "ghcr.io/blue-build/cli",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/bluebuild-cli.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "ghcr.io/blue-build/modules",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/bluebuild-modules.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "ghcr.io/sigstore/cosign",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/cosign-release.pub",
          signedIdentity = {
            type = "exactRepository",
            dockerRepository = "gcr.io/projectsigstore/cosign",
          },
        }
      ],
    },
    {
      registry = "gcr.io/projectsigstore",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/cosign-release.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "ghcr.io/wayblueorg",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/wayblueorg.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "ghcr.io/zelikos",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/davincibox.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "ghcr.io/jasonn3",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/build-container-installer.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "quay.io/toolbx-images",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/quay.io-toolbx-images.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "quay.io/fedora-ostree-desktops",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/quay.io-fedora-ostree-desktops.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "ghcr.io/ublue-os",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/ublue-os.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "ghcr.io/freedomofpress/dangerzone",
      policy = [
        {
          type = "sigstoreSigned",
          keyPath = "%{inputs.keys_dir}/containers/freedomofpress-dangerzone.pub",
          signedIdentity = { type = "matchRepository" },
        }
      ],
    },
    {
      registry = "registry.access.redhat.com",
      policy = [
        {
          type = "signedBy",
          keyType = "GPGKeys",
          keyPath = "/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release",
        }
      ],
    },
    {
      registry = "registry.redhat.io",
      policy = [
        {
          type = "signedBy",
          keyType = "GPGKeys",
          keyPath = "/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release",
        }
      ],
    },
    {
      registry = "",
      policy = [{ type = "reject" }],
    },
  ]
in

let transport_defaults = {
  atomic = { "" = [{ type = "reject" }] },
  dir = { "" = [{ type = "reject" }] },
  oci = { "" = [{ type = "reject" }] },
  oci-archive = { "" = [{ type = "reject" }] },
  tarball = { "" = [{ type = "reject" }] },

  docker-daemon = { "" = [{ type = "insecureAcceptAnything" }] },
  containers-storage = { "" = [{ type = "insecureAcceptAnything" }] },
  docker-archive = { "" = [{ type = "insecureAcceptAnything" }] },
}
in

{
  inputs | not_exported = {
    keys_dir
      | String
      | doc "directory for signing keys",

    host_insecure
      | Dyn
      | doc "per-host docker transport insecureAcceptAnything overrides"
      | optional
      = {},
  },

  default = [{ type = "reject" }],

  transports =
    transport_defaults
    & {
      docker = (base_docker inputs) & inputs.host_insecure,
    },
}
