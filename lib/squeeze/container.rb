require 'squeeze'
require 'securerandom'
require 'fileutils'
require 'tmpdir'
require 'libvirt'

module Squeeze
  class Container
    def initialize(name, base_path)
      @path = File.join(File.dirname(base_path), name)
      @name = name
      @base_path = base_path
      @connection = Libvirt.open("lxc:///")
    end

    def self.from_template(template)
      base_path = template.path
      name = "#{template.name}-#{SecureRandom.hex(4)}"
      self.new(name, base_path)
    end

    def run(command)
      setup
      sleep 120
      output = `ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -k #{@key} squeeze@#{@name}.local -- #{command.join(' ')}`
      teardown
      return output
    end

    def to_xml
<<EOF
<domain type='lxc'>
  <name>#{@name}</name>
  <memory>332768</memory>
  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>
  <vcpu>1</vcpu>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/lib/libvirt/libvirt_lxc</emulator>
    <filesystem type='mount'>
      <source dir='#{@path}'/>
      <target dir='/'/>
    </filesystem>
    <interface type='network'>
      <source network='default'/>
    </interface>
    <console type='pty' />
  </devices>
</domain>
EOF
    end

    protected

    def setup
      mount_filesystems
      update_hostname
      @domain = @connection.define_domain_xml(to_xml)
      @domain.create
    end

    def teardown
      @domain.destroy
      umount_filesystems
    end

    def update_hostname
      `sudo su -c 'echo #{@name} > #{File.join(@path, 'etc/hostname')}'`
    end

    def mount_filesystems
      FileUtils.mkdir_p @path
      @aufs_path = Dir.mktmpdir(@name)
      `sudo mount -t tmpfs none #{@aufs_path}`
      `sudo mount -t aufs -o br=#{@aufs_path}=rw:#{@base_path}=ro,noplink none #{@path}`
    end

    def umount_filesystems
      `sudo umount #{@path}`
      `sudo umount #{@aufs_path}`
      FileUtils.rmdir @path
      FileUtils.rmdir @aufs_path
    end
  end
end
