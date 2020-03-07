require_relative "../facts"
require_relative "../pip/pip"

module VagrantPlugins
  module Ansible
    module Cap
      module Guest
        module Alpine
          module AnsibleInstall

            def self.ansible_install(machine, install_mode, ansible_version, pip_args, pip_install_cmd = "")
              python_setup machine
              case install_mode
                when :pip
                  pip_setup machine
                  Pip::pip_install machine, "ansible", ansible_version, pip_args, true
                when :pip_args_only
                  pip_setup machine
                  Pip::pip_install machine, "", "", pip_args, false
                else
                  ansible_apk_install machine
              end
            end

            private

            def self.python_setup(machine)
              machine.communicate.sudo "apk add --update --no-cache python3"
              machine.communicate.sudo "if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi"
            end

            def self.ansible_apk_install(machine)
              machine.communicate.sudo "apk add --update --no-cache ansible"
            end

            def self.pip_setup(machine)
              machine.communicate.sudo "pip3 install --upgrade pip"
            end

          end
        end
      end
    end
  end
end
