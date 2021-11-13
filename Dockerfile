FROM centos:7

ENV PUPPET_AGENT_VERSION="5.2.0" R10K_VERSION="2.5.5" 

RUN curl --remote-name --location https://yum.puppet.com/RPM-GPG-KEY-puppet-20250406 && \
    gpg --keyid-format 0xLONG --with-fingerprint ./RPM-GPG-KEY-puppet-20250406 && \
    rpm --import RPM-GPG-KEY-puppet-20250406 && \
    rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm && \
    yum upgrade -y && \
    yum update -y && \
    yum install -y puppet-agent-"$PUPPET_AGENT_VERSION" && \
    yum install -y puppetserver && \
    mkdir -p /etc/puppetlabs/facter/facts.d/ && \
    yum clean all

RUN yum update -y && \
    yum install -y git && \
    /opt/puppetlabs/puppet/bin/gem install r10k:"$R10K_VERSION" --no-ri --no-rdoc && \
    /opt/puppetlabs/puppet/bin/gem install puppet-resource_api && \
    yum clean all

COPY Puppetfile /Puppetfile
RUN /opt/puppetlabs/puppet/bin/r10k puppetfile install --moduledir /etc/puppetlabs/code/modules

COPY manifests /manifests

  
    
RUN yum update -y && \
    FACTER_hostname=my-portfolio-image /opt/puppetlabs/bin/puppet apply manifests/init.pp --verbose --show_diff --summarize  --app_management && \
    yum clean all
    
  

LABEL com.puppet.inventory="/inventory.json"
RUN /opt/puppetlabs/bin/puppet module install puppetlabs-inventory && \
    /opt/puppetlabs/bin/puppet inventory all > /inventory.json
