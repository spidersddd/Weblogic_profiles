LFG Weblogic Workflow


This document is to describe the process for utilizing the weblogic
profiles to deploy the weblogic domains.<span
class="Apple-converted-space">  The main goal for the
profile::weblogic classes was to enforce some standards on deploying
with the weblogic module.<span class="Apple-converted-space"> 
</span>Profile classes are meant to pull some complexity out of
deploying weblogic as well as give some sane defaults for the LFG's
deployment of weblogic.<span class="Apple-converted-space"> 
</span>Configuration of the weblogic service can be done several ways
using the weblogic component module these profiles utilize the process
of calling a class and passing parameters to it, building a hash to pass
to a create\_resource function in puppet and calling additional classes
that provide those previous mentioned tasks to ensure the ordering
process. 

<span class="Apple-converted-space">  </span>

Key assumptions:

<span class="Apple-converted-space">  </span>Domain cluster consists of
1 x DomainAdmin, 2 x Nodemanagers, 2 x OHS hosts.

<span class="Apple-converted-space">  </span>One Domain per cluster.

<span class="Apple-converted-space">  </span>Weblogic 11g version

<span class="Apple-converted-space">  </span>

To utilize this code it requires a minimum of two facts:

<span class="Apple-converted-space">  </span>1) lfg\_sysrole = This
should come for the hostname of the host:

<span class="Apple-converted-space">    </span>wlsmgr = Domain admin

<span class="Apple-converted-space">    </span>wls <span
class="Apple-converted-space">      </span>= Node manager<span
class="Apple-converted-space"> </span>

<span class="Apple-converted-space">    </span>ohs <span
class="Apple-converted-space">      </span>= OHS host

<span class="Apple-converted-space">    </span>This facts is used to
determine what the wls\_role is, you can set this by creating a hiera
file for the host and adding 'wls\_role: &lt;role name&gt;' in it.<span
class="Apple-converted-space">  </span>This will then use that as the
role rather then the lfg\_sysrole determined method.<span
class="Apple-converted-space"> </span>

<span class="Apple-converted-space">  </span>2) wls\_domain = This is
the name of the domain to be deployed to the host.<span
class="Apple-converted-space">  </span>This could be dropped on the host
at provision time.<span class="Apple-converted-space">  </span>Create a
file on the host '/etc/puppetlabs/facter/facts.d/wls\_domain.txt' with
'wls\_domain=&lt;name&gt;'.<span class="Apple-converted-space"> 
</span>Example: wls\_domain=Wls1036

<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">  </span>Once those facts are
determined the class profile::weblogic will configure the machine based
on the applicable profile, 'profile::weblogic::domainadmin',
'profile::weblogic::nodemanager', and 'profile::weblogic::ohs' to the
specifications in the hieradata files.<span
class="Apple-converted-space">  </span>Example of a hieradata domain
file is bellow:

<span class="s1"><span
class="Apple-converted-space"> </span></span>*---*

*node1\_address:<span class="Apple-converted-space">           
</span>"172.22.5.40"*

*node2\_address:<span class="Apple-converted-space">           
</span>"172.22.5.41"*

*domain\_nodemanager\_port:<span class="Apple-converted-space"> 
</span>'5556'*

*wls\_version:<span class="Apple-converted-space">             
</span>'1036'*

*adminserver\_address:<span class="Apple-converted-space">     
</span>&adminserver\_address<span class="Apple-converted-space"> 
</span>"172.22.5.30"*

*logoutput:<span class="Apple-converted-space">               
</span>&logoutput<span class="Apple-converted-space">               
</span>true*

*log\_dir:<span class="Apple-converted-space">                 
</span>&log\_dir<span class="Apple-converted-space">                 
</span>'/opt/log/weblogic'*

*wls\_os\_user:<span class="Apple-converted-space">             
</span>&wls\_os\_user<span class="Apple-converted-space">             
</span>"webadmin"*

*wls\_os\_group: <span class="Apple-converted-space">           
</span>&wls\_os\_group <span class="Apple-converted-space">           
</span>"webadmns"*

*wls\_weblogic\_user:<span class="Apple-converted-space">       
</span>&wls\_weblogic\_user<span class="Apple-converted-space">       
</span>"weblogic"*

*wls\_weblogic\_home\_dir:<span class="Apple-converted-space">   
</span>&wls\_weblogic\_home\_dir<span class="Apple-converted-space">   
</span>"%{hiera('dft\_wls\_weblogic\_home\_dir')}"*

*wls\_middleware\_home\_dir:<span class="Apple-converted-space"> 
</span>&wls\_middleware\_home\_dir<span class="Apple-converted-space"> 
</span>"%{hiera('dft\_wls\_middleware\_home\_dir')}"*

*wls\_domains\_path: <span class="Apple-converted-space">       
</span>&wls\_domains\_path <span class="Apple-converted-space">       
</span>"%{hiera('dft\_wls\_domains\_path')}"*

*domain\_nodemanager\_port:<span class="Apple-converted-space"> 
</span>&domain\_nodemanager\_port<span class="Apple-converted-space"> 
</span>"%{hiera('dft\_domain\_nodemanager\_port')}"*

*Wls1036\_domain\_path:<span class="Apple-converted-space">     
</span>"%{hiera('wls\_domains\_path')}/Wls1036"*

*domain\_name:<span class="Apple-converted-space">               
</span>&domain\_name<span class="Apple-converted-space">               
</span>"%{::wls\_domain}"*

*domain\_adminserver: <span class="Apple-converted-space">       
</span>&domain\_adminserver <span class="Apple-converted-space">       
</span>"AdminServer"*

*domain\_adminserver\_address: &domain\_adminserver\_address
"%{hiera('adminserver\_address')}"*

*domain\_wls\_password:<span class="Apple-converted-space">       
</span>&domain\_wls\_password<span class="Apple-converted-space">       
</span>"%{hiera('dft\_wls\_weblogic\_password')}"*

*domain\_node1\_address: <span class="Apple-converted-space">     
</span>&domain\_node1\_address <span class="Apple-converted-space">     
</span>"%{hiera('node1\_address')}"*

*domain\_node2\_address: <span class="Apple-converted-space">     
</span>&domain\_node2\_address <span class="Apple-converted-space">     
</span>"%{hiera('node2\_address')}"*

*domain\_user\_config\_file:<span class="Apple-converted-space">   
</span>"/home/webadmin/wls-Wls1036-WebLogicConfig.properties"*

*domain\_user\_key\_file: <span class="Apple-converted-space">     
</span>"/home/webadmin/wls-Wls1036-WebLogicKey.properties"*

*userconfig\_instances:*

*<span class="Apple-converted-space"> </span>“%{hiera('wls\_os\_user')}"
:*

*<span class="Apple-converted-space">    </span>log\_output: <span
class="Apple-converted-space">          </span>\*logoutput*

*<span class="Apple-converted-space">    </span>user\_config\_dir:<span
class="Apple-converted-space">     
</span>"/home/%{hiera('wls\_os\_user')}"*


*authentication\_provider\_instances:*

*<span class="Apple-converted-space">  </span>'DefaultAuthenticator':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">            </span>'present'*

*<span class="Apple-converted-space">    </span>control\_flag: <span
class="Apple-converted-space">      </span>'SUFFICIENT'*

*<span class="Apple-converted-space">    </span>order:<span
class="Apple-converted-space">              </span>'0'*

*identity\_asserter\_instances:*

*<span class="Apple-converted-space"> 
</span>'DefaultIdentityAsserter':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">            </span>'present'*

*<span class="Apple-converted-space">    </span>providerclassname:<span
class="Apple-converted-space"> 
</span>'weblogic.security.providers.authentication.DefaultIdentityAsserter'*

*<span class="Apple-converted-space">    </span>activetypes:<span
class="Apple-converted-space">        </span>'AuthenticatedUser'*

*<span class="Apple-converted-space">    </span>defaultmappertype:<span
class="Apple-converted-space">  </span>'E'*

*<span class="Apple-converted-space">    </span>before: <span
class="Apple-converted-space">            </span>Wls\_domain\[Wls1036\]*

*wls\_domain\_instances:*

*<span class="Apple-converted-space">  </span>'Wls1036':*

*<span class="Apple-converted-space">    </span>ensure:<span
class="Apple-converted-space">                      </span>'present'*

*<span class="Apple-converted-space">   
</span>jpa\_default\_provider:<span class="Apple-converted-space">     
  </span>'org.eclipse.persistence.jpa.PersistenceProvider'*

*<span class="Apple-converted-space">   
</span>jta\_max\_transactions:<span class="Apple-converted-space">     
  </span>'20000'*

*<span class="Apple-converted-space">   
</span>jta\_transaction\_timeout: <span class="Apple-converted-space"> 
  </span>'35'*

*<span class="Apple-converted-space">    </span>log\_file\_min\_size:
<span class="Apple-converted-space">          </span>'5000'*

*<span class="Apple-converted-space">    </span>log\_filecount: <span
class="Apple-converted-space">              </span>'10'*

*<span class="Apple-converted-space">    </span>log\_filename:<span
class="Apple-converted-space">               
</span>"%{hiera('log\_dir')}/Wls1036.log"*

*<span class="Apple-converted-space">   
</span>log\_number\_of\_files\_limited: '1'*

*<span class="Apple-converted-space">   
</span>log\_rotate\_logon\_startup:<span class="Apple-converted-space"> 
  </span>'1'*

*<span class="Apple-converted-space">    </span>log\_rotationtype:<span
class="Apple-converted-space">            </span>'bySize'*

*<span class="Apple-converted-space">   
</span>security\_crossdomain:<span class="Apple-converted-space">       
</span>'0'*

*wls\_adminserver\_instances\_domain:*

*<span class="Apple-converted-space">  </span>'AdminServer\_Wls1036':*

*<span class="Apple-converted-space">    </span>ensure:<span
class="Apple-converted-space">                    </span>'running'*

*<span class="Apple-converted-space">    </span>server\_name: <span
class="Apple-converted-space">             
</span>\*domain\_adminserver*

*<span class="Apple-converted-space">    </span>domain\_name: <span
class="Apple-converted-space">              </span>\*domain\_name*

*<span class="Apple-converted-space">    </span>domain\_path: <span
class="Apple-converted-space">             
</span>"%{hiera('Wls1036\_domain\_path')}"*

*<span class="Apple-converted-space">    </span>os\_user: <span
class="Apple-converted-space">                  </span>\*wls\_os\_user*

*<span class="Apple-converted-space">    </span>weblogic\_home\_dir:
<span class="Apple-converted-space">       
</span>\*wls\_weblogic\_home\_dir*

*<span class="Apple-converted-space">    </span>weblogic\_user: <span
class="Apple-converted-space">            </span>\*wls\_weblogic\_user*

*<span class="Apple-converted-space">    </span>weblogic\_password:
<span class="Apple-converted-space">       
</span>\*domain\_wls\_password*

*<span class="Apple-converted-space">    </span>jdk\_home\_dir:<span
class="Apple-converted-space">              </span>'/usr/java/latest'*

*<span class="Apple-converted-space">    </span>nodemanager\_address:
<span class="Apple-converted-space">     
</span>\*domain\_adminserver\_address*

*<span class="Apple-converted-space">    </span>nodemanager\_port:<span
class="Apple-converted-space">         
</span>\*domain\_nodemanager\_port*

*<span class="Apple-converted-space">    </span>jsse\_enabled:<span
class="Apple-converted-space">              </span>true*

*<span class="Apple-converted-space">    </span>refreshonly: <span
class="Apple-converted-space">              </span>true*

*<span class="Apple-converted-space">    </span>subscribe: <span
class="Apple-converted-space">               
</span>Wls\_domain\[Wls1036\]*

*user\_instances:*

*<span class="Apple-converted-space">  </span>'testuser1':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">                </span>'present'*

*<span class="Apple-converted-space">    </span>password: <span
class="Apple-converted-space">              </span>'weblogic1'*

*<span class="Apple-converted-space">    </span>authenticationprovider:
'DefaultAuthenticator'*

*<span class="Apple-converted-space">    </span>realm:<span
class="Apple-converted-space">                  </span>'myrealm'*

*<span class="Apple-converted-space">    </span>description:<span
class="Apple-converted-space">            </span>'my test user'*

*group\_instances:*

*<span class="Apple-converted-space">  </span>'TestGroup':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">                </span>'present'*

*<span class="Apple-converted-space">    </span>authenticationprovider:
'DefaultAuthenticator'*

*<span class="Apple-converted-space">    </span>description:<span
class="Apple-converted-space">            </span>'My TestGroup'*

*<span class="Apple-converted-space">    </span>realm:<span
class="Apple-converted-space">                  </span>'myrealm'*

*<span class="Apple-converted-space">    </span>users:*

*<span class="Apple-converted-space">      </span>- 'testuser1'*


*machines\_instances:*

*<span class="Apple-converted-space">  </span>'LocalMachine':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">        </span>'present'*

*<span class="Apple-converted-space">    </span>listenaddress:<span
class="Apple-converted-space">  </span>\*domain\_adminserver\_address*

*<span class="Apple-converted-space">    </span>listenport: <span
class="Apple-converted-space">    </span>'5556'*

*<span class="Apple-converted-space">    </span>machinetype:<span
class="Apple-converted-space">    </span>'UnixMachine'*

*<span class="Apple-converted-space">    </span>nmtype: <span
class="Apple-converted-space">        </span>'SSL'*

*<span class="Apple-converted-space">  </span>'nc2pxwls100':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">        </span>'present'*

*<span class="Apple-converted-space">    </span>listenaddress:<span
class="Apple-converted-space">  </span>\*domain\_node1\_address*

*<span class="Apple-converted-space">    </span>listenport: <span
class="Apple-converted-space">    </span>'5556'*

*<span class="Apple-converted-space">    </span>machinetype:<span
class="Apple-converted-space">    </span>'UnixMachine'*

*<span class="Apple-converted-space">    </span>nmtype: <span
class="Apple-converted-space">        </span>'SSL'*

*<span class="Apple-converted-space">  </span>'nc2pxwls101':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">        </span>'present'*

*<span class="Apple-converted-space">    </span>listenaddress:<span
class="Apple-converted-space">  </span>\*domain\_node2\_address*

*<span class="Apple-converted-space">    </span>listenport: <span
class="Apple-converted-space">    </span>'5556'*

*<span class="Apple-converted-space">    </span>machinetype:<span
class="Apple-converted-space">    </span>'UnixMachine'*

*<span class="Apple-converted-space">    </span>nmtype: <span
class="Apple-converted-space">        </span>'SSL'*

*server\_vm\_args\_permsize:<span class="Apple-converted-space">     
</span>&server\_vm\_args\_permsize <span class="Apple-converted-space"> 
  </span>'-XX:PermSize=256m'*

*server\_vm\_args\_max\_permsize:<span class="Apple-converted-space"> 
</span>&server\_vm\_args\_max\_permsize '-XX:MaxPermSize=256m'*

*server\_vm\_args\_memory:<span class="Apple-converted-space">       
</span>&server\_vm\_args\_memory <span class="Apple-converted-space">   
  </span>'-Xms752m'*

*server\_vm\_args\_max\_memory:<span class="Apple-converted-space">   
</span>&server\_vm\_args\_max\_memory <span
class="Apple-converted-space">  </span>'-Xmx752m'*

*wls\_java\_arguments:*

*<span class="Apple-converted-space">  </span>-
\*server\_vm\_args\_permsize*

*<span class="Apple-converted-space">  </span>-
\*server\_vm\_args\_max\_permsize*

*<span class="Apple-converted-space">  </span>-
\*server\_vm\_args\_memory*

*<span class="Apple-converted-space">  </span>-
\*server\_vm\_args\_max\_memory*

*<span class="Apple-converted-space">  </span>-
"-Dweblogic.Stdout=%{hiera('log\_dir')}/\${title}.out"*

*<span class="Apple-converted-space">  </span>-
"-Dweblogic.Stderr=%{hiera('log\_dir')}/\${title}\_err.out"*

*<span class="Apple-converted-space">  </span>-
'-Dweblogic.security.SSL.enforceConstraints=off'*

*<span class="Apple-converted-space">  </span>- '-Dssl.debug=true'*

*<span class="Apple-converted-space">  </span>-
'-Dweblogic.security.SSL.ignoreHostnameVerification=true'*

*<span class="Apple-converted-space">  </span>-
'-Dweblogic.security.TrustKeyStore=DemoTrust'*


*server\_instances:*

*<span class="Apple-converted-space">  </span>'AdminServer':*

*<span class="Apple-converted-space">    </span>ensure:<span
class="Apple-converted-space">                               
</span>'present'*

*<span class="Apple-converted-space">    </span>arguments:<span
class="Apple-converted-space">                         
</span>“%{hiera('wls\_java\_arguments')}”*

*<span class="Apple-converted-space">    </span>listenaddress:<span
class="Apple-converted-space">                     
</span>\*domain\_adminserver\_address*

*<span class="Apple-converted-space">    </span>listenport:<span
class="Apple-converted-space">                            </span>'7001'*

*<span class="Apple-converted-space">    </span>machine: <span
class="Apple-converted-space">                             
</span>'LocalMachine'*

*<span class="Apple-converted-space">    </span>logfilename: <span
class="Apple-converted-space">                         
</span>"%{hiera('log\_dir')}/AdminServer.log"*

*<span class="Apple-converted-space">   
</span>log\_datasource\_filename: <span class="Apple-converted-space"> 
            </span>"%{hiera('log\_dir')}/AdminServer\_datasource.log"*

*<span class="Apple-converted-space">    </span>log\_file\_min\_size:
<span class="Apple-converted-space">                    </span>'2000'*

*<span class="Apple-converted-space">    </span>log\_filecount: <span
class="Apple-converted-space">                        </span>'10'*

*<span class="Apple-converted-space">   
</span>log\_number\_of\_files\_limited: <span
class="Apple-converted-space">          </span>'1'*

*<span class="Apple-converted-space">   
</span>log\_rotate\_logon\_startup:<span class="Apple-converted-space"> 
            </span>'1'*

*<span class="Apple-converted-space">    </span>log\_rotationtype:<span
class="Apple-converted-space">                      </span>'bySize'*

*<span class="Apple-converted-space">    </span>log\_http\_filename:
<span class="Apple-converted-space">                   
</span>"%{hiera('log\_dir')}/AdminServer\_access.log"*

*<span class="Apple-converted-space">   
</span>log\_http\_format\_type:<span class="Apple-converted-space">     
            </span>'extended'*

*<span class="Apple-converted-space">    </span>log\_http\_format: <span
class="Apple-converted-space">                      </span>'date time
x-XForwardedFor s-ip cs-method cs-uri x-SOAPAction sc-status bytes
time-taken x-UserAgent'*

*<span class="Apple-converted-space">    </span>tunnelingenabled:<span
class="Apple-converted-space">                      </span>'0'*

*<span class="Apple-converted-space">    </span>max\_message\_size:<span
class="Apple-converted-space">                      </span>'10000000'*

*<span class="Apple-converted-space">    </span>sslenabled:<span
class="Apple-converted-space">                            </span>'0'*

*<span class="Apple-converted-space">    </span>ssllistenport: <span
class="Apple-converted-space">                        </span>'7002'*

*<span class="Apple-converted-space">   
</span>sslhostnameverificationignored:<span
class="Apple-converted-space">        </span>'1'*

*<span class="Apple-converted-space">    </span>two\_way\_ssl: <span
class="Apple-converted-space">                          </span>'0'*

*<span class="Apple-converted-space">   
</span>client\_certificate\_enforced: <span
class="Apple-converted-space">          </span>'0'*

*<span class="Apple-converted-space">    </span>jsseenabled: <span
class="Apple-converted-space">                          </span>'1'*

*<span class="Apple-converted-space">  </span>'wlsServer1':*

*<span class="Apple-converted-space">    </span>ensure:<span
class="Apple-converted-space">                               
</span>'present'*

*<span class="Apple-converted-space">     </span>arguments:<span
class="Apple-converted-space">                         
</span>“%{hiera('wls\_java\_arguments')}”*

*<span class="Apple-converted-space">    </span>listenaddress: <span
class="Apple-converted-space">                       
</span>\*domain\_node1\_address*

*<span class="Apple-converted-space">    </span>listenport:<span
class="Apple-converted-space">                            </span>'8001'*

*<span class="Apple-converted-space">    </span>logfilename: <span
class="Apple-converted-space">                         
</span>"%{hiera('log\_dir')}/wlsServer1.log"*

*<span class="Apple-converted-space">   
</span>log\_datasource\_filename: <span class="Apple-converted-space"> 
            </span>"%{hiera('log\_dir')}/wlsServer1\_datasource.log"*

*<span class="Apple-converted-space">    </span>log\_http\_filename:
<span class="Apple-converted-space">                   
</span>"%{hiera('log\_dir')}/wlsServer1\_access.log"*

*<span class="Apple-converted-space">    </span>log\_file\_min\_size:
<span class="Apple-converted-space">                    </span>'2000'*

*<span class="Apple-converted-space">    </span>log\_filecount: <span
class="Apple-converted-space">                        </span>'10'*

*<span class="Apple-converted-space">   
</span>log\_number\_of\_files\_limited: <span
class="Apple-converted-space">          </span>'1'*

*<span class="Apple-converted-space">   
</span>log\_rotate\_logon\_startup:<span class="Apple-converted-space"> 
            </span>'1'*

*<span class="Apple-converted-space">    </span>log\_rotationtype:<span
class="Apple-converted-space">                      </span>'bySize'*

*<span class="Apple-converted-space">    </span>machine: <span
class="Apple-converted-space">                             
</span>'nc2pxwls100'*

*<span class="Apple-converted-space">    </span>sslenabled:<span
class="Apple-converted-space">                            </span>'1'*

*<span class="Apple-converted-space">    </span>ssllistenport: <span
class="Apple-converted-space">                        </span>'8201'*

*<span class="Apple-converted-space">   
</span>sslhostnameverificationignored:<span
class="Apple-converted-space">        </span>'1'*

*<span class="Apple-converted-space">    </span>two\_way\_ssl: <span
class="Apple-converted-space">                          </span>'0'*

*<span class="Apple-converted-space">   
</span>client\_certificate\_enforced: <span
class="Apple-converted-space">          </span>'0'*

*<span class="Apple-converted-space">    </span>jsseenabled: <span
class="Apple-converted-space">                          </span>'1'*

*<span class="Apple-converted-space">    </span>max\_message\_size:<span
class="Apple-converted-space">                      </span>'25000000'*

*<span class="Apple-converted-space">    </span>notify:<span
class="Apple-converted-space">                               
</span>Wls\_adminserver\[AdminServer\_Wls1036\]*

*<span class="Apple-converted-space">  </span>'wlsServer2':*

*<span class="Apple-converted-space">    </span>ensure:<span
class="Apple-converted-space">                               
</span>'present'*

*<span class="Apple-converted-space">    </span>arguments:<span
class="Apple-converted-space">                         
</span>“%{hiera('wls\_java\_arguments')}”*

*<span class="Apple-converted-space">    </span>listenport:<span
class="Apple-converted-space">                            </span>'8001'*

*<span class="Apple-converted-space">    </span>logfilename: <span
class="Apple-converted-space">                         
</span>"%{hiera('log\_dir')}/wlsServer2.log"*

*<span class="Apple-converted-space">   
</span>log\_datasource\_filename: <span class="Apple-converted-space"> 
            </span>"%{hiera('log\_dir')}/wlsServer2\_datasource.log"*

*<span class="Apple-converted-space">    </span>log\_http\_filename:
<span class="Apple-converted-space">                   
</span>"%{hiera('log\_dir')}/wlsServer2\_access.log"*

*<span class="Apple-converted-space">    </span>log\_file\_min\_size:
<span class="Apple-converted-space">                    </span>'2000'*

*<span class="Apple-converted-space">    </span>log\_filecount: <span
class="Apple-converted-space">                        </span>'10'*

*<span class="Apple-converted-space">   
</span>log\_number\_of\_files\_limited: <span
class="Apple-converted-space">          </span>'1'*

*<span class="Apple-converted-space">   
</span>log\_rotate\_logon\_startup:<span class="Apple-converted-space"> 
            </span>'1'*

*<span class="Apple-converted-space">    </span>log\_rotationtype:<span
class="Apple-converted-space">                      </span>'bySize'*

*<span class="Apple-converted-space">    </span>machine: <span
class="Apple-converted-space">                             
</span>'nc2pxwls101'*

*<span class="Apple-converted-space">    </span>sslenabled:<span
class="Apple-converted-space">                            </span>'1'*

*<span class="Apple-converted-space">    </span>ssllistenport: <span
class="Apple-converted-space">                        </span>'8201'*

*<span class="Apple-converted-space">   
</span>sslhostnameverificationignored:<span
class="Apple-converted-space">        </span>'1'*

*<span class="Apple-converted-space">    </span>listenaddress: <span
class="Apple-converted-space">                       
</span>\*domain\_node2\_address*

*<span class="Apple-converted-space">    </span>jsseenabled: <span
class="Apple-converted-space">                          </span>'1'*

*<span class="Apple-converted-space">    </span>max\_message\_size:<span
class="Apple-converted-space">                      </span>'25000000'*

*<span class="Apple-converted-space">    </span>notify:<span
class="Apple-converted-space">                               
</span>Wls\_adminserver\[AdminServer\_Wls1036\]*

*wls\_adminserver\_instances\_server:*

*<span class="Apple-converted-space"> 
</span>'AdminServer\_Wls1036\_2':*

*<span class="Apple-converted-space">    </span>ensure:<span
class="Apple-converted-space">                    </span>'running'*

*<span class="Apple-converted-space">    </span>server\_name: <span
class="Apple-converted-space">             
</span>\*domain\_adminserver*

*<span class="Apple-converted-space">    </span>domain\_name: <span
class="Apple-converted-space">              </span>\*domain\_name*

*<span class="Apple-converted-space">    </span>domain\_path: <span
class="Apple-converted-space">             
</span>"%{hiera('Wls1036\_domain\_path')}"*

*<span class="Apple-converted-space">    </span>os\_user: <span
class="Apple-converted-space">                  </span>\*wls\_os\_user*

*<span class="Apple-converted-space">    </span>weblogic\_home\_dir:
<span class="Apple-converted-space">       
</span>\*wls\_weblogic\_home\_dir*

*<span class="Apple-converted-space">    </span>weblogic\_user: <span
class="Apple-converted-space">            </span>\*wls\_weblogic\_user*

*<span class="Apple-converted-space">    </span>weblogic\_password:
<span class="Apple-converted-space">       
</span>\*domain\_wls\_password*

*<span class="Apple-converted-space">    </span>jdk\_home\_dir:<span
class="Apple-converted-space">              </span>'/usr/java/latest'*

*<span class="Apple-converted-space">    </span>nodemanager\_address:
<span class="Apple-converted-space">     
</span>\*domain\_adminserver\_address*

*<span class="Apple-converted-space">    </span>nodemanager\_port:<span
class="Apple-converted-space">         
</span>\*domain\_nodemanager\_port*

*<span class="Apple-converted-space">    </span>jsse\_enabled:<span
class="Apple-converted-space">              </span>true*

*<span class="Apple-converted-space">    </span>refreshonly: <span
class="Apple-converted-space">              </span>true*

*<span class="Apple-converted-space">    </span>subscribe: <span
class="Apple-converted-space">               
</span>Wls\_server\[AdminServer\]*

*server\_channel\_instances:*

*<span class="Apple-converted-space"> 
</span>'wlsServer1:Channel-Cluster':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">          </span>'present'*

*<span class="Apple-converted-space">    </span>enabled:<span
class="Apple-converted-space">          </span>'1'*

*<span class="Apple-converted-space">    </span>httpenabled:<span
class="Apple-converted-space">      </span>'1'*

*<span class="Apple-converted-space">    </span>listenaddress:<span
class="Apple-converted-space">    </span>\*domain\_node1\_address*

*<span class="Apple-converted-space">    </span>listenport: <span
class="Apple-converted-space">      </span>'8003'*

*<span class="Apple-converted-space">    </span>outboundenabled:<span
class="Apple-converted-space">  </span>'0'*

*<span class="Apple-converted-space">    </span>protocol: <span
class="Apple-converted-space">        </span>'cluster-broadcast'*

*<span class="Apple-converted-space">    </span>publicaddress:<span
class="Apple-converted-space">    </span>\*domain\_node1\_address*

*<span class="Apple-converted-space">    </span>tunnelingenabled: '0'*

*<span class="Apple-converted-space"> 
</span>'wlsServer2:Channel-Cluster':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">          </span>'present'*

*<span class="Apple-converted-space">    </span>enabled:<span
class="Apple-converted-space">          </span>'1'*

*<span class="Apple-converted-space">    </span>httpenabled:<span
class="Apple-converted-space">      </span>'1'*

*<span class="Apple-converted-space">    </span>listenaddress:<span
class="Apple-converted-space">    </span>\*domain\_node2\_address*

*<span class="Apple-converted-space">    </span>listenport: <span
class="Apple-converted-space">      </span>'8003'*

*<span class="Apple-converted-space">    </span>outboundenabled:<span
class="Apple-converted-space">  </span>'0'*

*<span class="Apple-converted-space">    </span>protocol: <span
class="Apple-converted-space">        </span>'cluster-broadcast'*

*<span class="Apple-converted-space">    </span>publicaddress:<span
class="Apple-converted-space">    </span>\*domain\_node2\_address*

*<span class="Apple-converted-space">    </span>tunnelingenabled: '0'*

*<span class="Apple-converted-space">  </span>'wlsServer1:HTTP':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">          </span>'present'*

*<span class="Apple-converted-space">    </span>enabled:<span
class="Apple-converted-space">          </span>'1'*

*<span class="Apple-converted-space">    </span>httpenabled:<span
class="Apple-converted-space">      </span>'1'*

*<span class="Apple-converted-space">    </span>listenport: <span
class="Apple-converted-space">      </span>'8004'*

*<span class="Apple-converted-space">    </span>publicport: <span
class="Apple-converted-space">      </span>'8104'*

*<span class="Apple-converted-space">    </span>outboundenabled:<span
class="Apple-converted-space">  </span>'0'*

*<span class="Apple-converted-space">    </span>protocol: <span
class="Apple-converted-space">        </span>'http'*

*<span class="Apple-converted-space">    </span>tunnelingenabled: '0'*

*<span class="Apple-converted-space">    </span>max\_message\_size:
'35000000'*

*<span class="Apple-converted-space">  </span>'wlsServer2:HTTP':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">          </span>'present'*

*<span class="Apple-converted-space">    </span>enabled:<span
class="Apple-converted-space">          </span>'1'*

*<span class="Apple-converted-space">    </span>httpenabled:<span
class="Apple-converted-space">      </span>'1'*

*<span class="Apple-converted-space">    </span>listenport: <span
class="Apple-converted-space">      </span>'8004'*

*<span class="Apple-converted-space">    </span>publicport: <span
class="Apple-converted-space">      </span>'8104'*

*<span class="Apple-converted-space">    </span>outboundenabled:<span
class="Apple-converted-space">  </span>'0'*

*<span class="Apple-converted-space">    </span>protocol: <span
class="Apple-converted-space">        </span>'http'*

*<span class="Apple-converted-space">    </span>tunnelingenabled: '0'*

*<span class="Apple-converted-space">    </span>max\_message\_size:
'35000000'*

*cluster\_instances:*

*<span class="Apple-converted-space">  </span>'WebCluster':*

*<span class="Apple-converted-space">    </span>ensure: <span
class="Apple-converted-space">                    </span>'present'*

*<span class="Apple-converted-space">    </span>migrationbasis: <span
class="Apple-converted-space">            </span>'database'*

*<span class="Apple-converted-space">    </span>servers:*

*<span class="Apple-converted-space">      </span>- 'wlsServer1'*

*<span class="Apple-converted-space">      </span>- 'wlsServer2'*

*<span class="Apple-converted-space">    </span>messagingmode:<span
class="Apple-converted-space">              </span>'unicast'*

*<span class="Apple-converted-space">   
</span>unicastbroadcastchannel:<span class="Apple-converted-space">   
</span>'Channel-Cluster'*

*<span class="Apple-converted-space">    </span>frontendhost: <span
class="Apple-converted-space">             
</span>\*domain\_adminserver\_address*

*<span class="Apple-converted-space">    </span>frontendhttpport: <span
class="Apple-converted-space">          </span>'2001'*

*<span class="Apple-converted-space">    </span>frontendhttpsport:<span
class="Apple-converted-space">          </span>'2002'*

*datasource\_instances:*

*<span class="Apple-converted-space">    </span>'hrDS':*

*<span class="Apple-converted-space">      </span>ensure:<span
class="Apple-converted-space">                      </span>'present'*

*<span class="Apple-converted-space">      </span>drivername:<span
class="Apple-converted-space">                 
</span>'oracle.jdbc.xa.client.OracleXADataSource'*

*<span class="Apple-converted-space">      </span>extraproperties:*

*<span class="Apple-converted-space">        </span>-
'SendStreamAsBlob=true'*

*<span class="Apple-converted-space">        </span>-
'oracle.net.CONNECT\_TIMEOUT=10001'*

*<span class="Apple-converted-space">     
</span>globaltransactionsprotocol:<span class="Apple-converted-space"> 
</span>'TwoPhaseCommit'*

*<span class="Apple-converted-space">      </span>initialcapacity: <span
class="Apple-converted-space">            </span>'2'*

*<span class="Apple-converted-space">      </span>jndinames:*

*<span class="Apple-converted-space">        </span>- 'jdbc/hrDS'*

*<span class="Apple-converted-space">        </span>- 'jdbc/hrDS2'*

*<span class="Apple-converted-space">      </span>maxcapacity: <span
class="Apple-converted-space">                </span>'15'*

*<span class="Apple-converted-space">      </span>target:*

*<span class="Apple-converted-space">        </span>- 'wlsServer1'*

*<span class="Apple-converted-space">        </span>- 'wlsServer2'*

*<span class="Apple-converted-space">      </span>targettype:*

*<span class="Apple-converted-space">        </span>- 'Server'*

*<span class="Apple-converted-space">        </span>- 'Server'*

*<span class="Apple-converted-space">      </span>testtablename: <span
class="Apple-converted-space">              </span>'SQL SELECT 1 FROM
DUAL'*

*<span class="Apple-converted-space">      </span>url: <span
class="Apple-converted-space">                       
</span>"jdbc:oracle:thin:@dbagent2.alfa.local:1521/test.oracle.com"*

*<span class="Apple-converted-space">      </span>user:<span
class="Apple-converted-space">                        </span>'hr'*

*<span class="Apple-converted-space">      </span>password:<span
class="Apple-converted-space">                    </span>'hr'*

*<span class="Apple-converted-space">      </span>usexa: <span
class="Apple-converted-space">                      </span>'1'*

*<span class="Apple-converted-space">    </span>'jmsDS':*

*<span class="Apple-converted-space">      </span>ensure:<span
class="Apple-converted-space">                      </span>'present'*

*<span class="Apple-converted-space">      </span>drivername:<span
class="Apple-converted-space">                 
</span>'com.mysql.jdbc.Driver'*

*<span class="Apple-converted-space">     
</span>globaltransactionsprotocol:<span class="Apple-converted-space"> 
</span>'None'*

*<span class="Apple-converted-space">      </span>initialcapacity: <span
class="Apple-converted-space">            </span>'0'*

*<span class="Apple-converted-space">      </span>jndinames:*

*<span class="Apple-converted-space">        </span>- 'jmsDS'*

*<span class="Apple-converted-space">      </span>maxcapacity: <span
class="Apple-converted-space">                </span>'15'*

*<span class="Apple-converted-space">      </span>target:*

*<span class="Apple-converted-space">        </span>- 'wlsServer1'*

*<span class="Apple-converted-space">        </span>- 'wlsServer2'*

*<span class="Apple-converted-space">      </span>targettype:*

*<span class="Apple-converted-space">        </span>- 'Server'*

*<span class="Apple-converted-space">        </span>- 'Server'*

*<span class="Apple-converted-space">      </span>testtablename: <span
class="Apple-converted-space">              </span>'SQL SELECT 1'*

*<span class="Apple-converted-space">      </span>url: <span
class="Apple-converted-space">                       
</span>'jdbc:mysql://10.10.10.10:3306/jms'*

*<span class="Apple-converted-space">      </span>user:<span
class="Apple-converted-space">                        </span>'jms'*

*<span class="Apple-converted-space">      </span>password:<span
class="Apple-converted-space">                    </span>'jms'*

*<span class="Apple-converted-space">      </span>usexa: <span
class="Apple-converted-space">                      </span>'1'*

*file\_persistence\_folders:*

*<span class="Apple-converted-space">  
</span>"%{hiera('Wls1036\_domain\_path')}/persistence1":*

*<span class="Apple-converted-space">      </span>ensure: <span
class="Apple-converted-space">    </span>directory*

*<span class="Apple-converted-space">      </span>recurse:<span
class="Apple-converted-space">    </span>false*

*<span class="Apple-converted-space">      </span>replace:<span
class="Apple-converted-space">    </span>false*

*<span class="Apple-converted-space">      </span>mode: <span
class="Apple-converted-space">      </span>'0775'*

*<span class="Apple-converted-space">      </span>owner:<span
class="Apple-converted-space">      </span>\*wls\_os\_user*

*<span class="Apple-converted-space">      </span>group:<span
class="Apple-converted-space">      </span>\*wls\_os\_group*

*<span class="Apple-converted-space">  
</span>"%{hiera('Wls1036\_domain\_path')}/persistence2":*

*<span class="Apple-converted-space">      </span>ensure: <span
class="Apple-converted-space">    </span>directory*

*<span class="Apple-converted-space">      </span>recurse:<span
class="Apple-converted-space">    </span>false*

*<span class="Apple-converted-space">      </span>replace:<span
class="Apple-converted-space">    </span>false*

*<span class="Apple-converted-space">      </span>mode: <span
class="Apple-converted-space">      </span>'0775'*

*<span class="Apple-converted-space">      </span>owner:<span
class="Apple-converted-space">      </span>\*wls\_os\_user*

*<span class="Apple-converted-space">      </span>group:<span
class="Apple-converted-space">      </span>\*wls\_os\_group*

*<span class="Apple-converted-space">  
</span>"%{hiera('Wls1036\_domain\_path')}/persistence3":*

*<span class="Apple-converted-space">      </span>ensure: <span
class="Apple-converted-space">    </span>directory*

*<span class="Apple-converted-space">      </span>recurse:<span
class="Apple-converted-space">    </span>false*

*<span class="Apple-converted-space">      </span>replace:<span
class="Apple-converted-space">    </span>false*

*<span class="Apple-converted-space">      </span>mode: <span
class="Apple-converted-space">      </span>'0775'*

*<span class="Apple-converted-space">      </span>owner:<span
class="Apple-converted-space">      </span>\*wls\_os\_user*

*<span class="Apple-converted-space">      </span>group:<span
class="Apple-converted-space">      </span>\*wls\_os\_group*

<span class="Apple-converted-space">  </span>In the Puppet Enterprise
console under Classification Tab a group should be created for each of
the environments required.<span class="Apple-converted-space"> 
</span>The group should have the class 'profile::weblogic' or a group
for each weblogic host type can be created and assigned the applicable
class.<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">  </span>The
'profile::weblogic::&lt;type&gt;' use a params class located at
'profile::weblogic::params' to build out a parameters list that can be
utilized across different classes and resources.<span
class="Apple-converted-space">  </span>This profile module tries to
utilize the same parameters as listed and used in the
abrader-weblogic<span class="s2">/</span><span
class="s3">***biemond-orawls module documentation.<span
class="Apple-converted-space">  </span>LFG is using the abrader-weblogic
module that was based on the biemond-orawls module.<span
class="Apple-converted-space">  </span>This module and code has been
checked into the LFG git server.***</span>

<span class="s4">***Bellow is an example of the params.pp file in the
weblogic profile.***</span>

*class profile::weblogic::params {*

*<span class="Apple-converted-space">  </span>\$wls\_domain<span
class="Apple-converted-space">                            </span>=
"\${::wls\_domain}"*

*<span class="Apple-converted-space">  </span>\$param\_lfg\_sysrole
<span class="Apple-converted-space">                    </span>=
"\${::lfg\_sysrole}"*

*<span class="Apple-converted-space">  </span>\$jdk\_home\_dir<span
class="Apple-converted-space">                          </span>=
hiera('profile::weblogic::jdk\_home\_dir', '/usr/java/latest')*

*<span class="Apple-converted-space">  </span>\$download\_dir<span
class="Apple-converted-space">                          </span>=
hiera('download\_dir', '/tmp/oracle')*

*<span class="Apple-converted-space">  </span>\$fmw\_plugins <span
class="Apple-converted-space">                          </span>=
hiera\_hash('profile::weblogic::base::addons', {})*

*<span class="Apple-converted-space">  </span>\$opatch<span
class="Apple-converted-space">                                </span>=
hiera\_hash('profile::weblogic::base::opatch', {})*

*<span class="Apple-converted-space">  </span>\$wls\_version <span
class="Apple-converted-space">                          </span>=
hiera('wls\_version', 1036)*

*<span class="Apple-converted-space">  </span>\$wls\_os\_user <span
class="Apple-converted-space">                          </span>=
hiera('wls\_os\_user', 'webadmin')*

*<span class="Apple-converted-space">  </span>\$wls\_os\_group<span
class="Apple-converted-space">                          </span>=
hiera('wls\_os\_group', 'webadmns')*

*<span class="Apple-converted-space">  </span>\$wls\_weblogic\_user
<span class="Apple-converted-space">                    </span>=
'weblogic'*

*<span class="Apple-converted-space">  </span>\$wls\_weblogic\_password
<span class="Apple-converted-space">                </span>=
'weblogic1'*

*<span class="Apple-converted-space"> 
</span>\$wls\_oracle\_base\_home\_dir<span
class="Apple-converted-space">              </span>= '/opt/was/oracle'*

*<span class="Apple-converted-space"> 
</span>\$wls\_middleware\_home\_dir <span
class="Apple-converted-space">              </span>=
hiera('wls\_middleware\_home\_dir',
"\${wls\_oracle\_base\_home\_dir}/middleware/\${wls\_version}")*

*<span class="Apple-converted-space">  </span>\$wls\_weblogic\_home\_dir
<span class="Apple-converted-space">                </span>=
hiera('wls\_weblogic\_home\_dir',
"\${wls\_middleware\_home\_dir}/wlserver")*

*<span class="Apple-converted-space">  </span>\$wls\_domains\_path<span
class="Apple-converted-space">                      </span>=
hiera('domains\_dir',
"\${wls\_middleware\_home\_dir}/user\_projects/domains")*

*<span class="Apple-converted-space">  </span>\$apps\_dir<span
class="Apple-converted-space">                              </span>=
hiera('wls\_apps\_dir',
"\${wls\_middleware\_home\_dir}/user\_projects/applications")*

*<span class="Apple-converted-space">  </span>\$wls\_log\_output<span
class="Apple-converted-space">                        </span>=
hiera('log\_outpu', true)*

*<span class="Apple-converted-space">  </span>\$wls\_log\_dir <span
class="Apple-converted-space">                          </span>=
'/opt/log/weblogic'*

*<span class="Apple-converted-space">  </span>\$adminserver\_name<span
class="Apple-converted-space">                      </span>=
hiera('adminserver\_name', 'AdminServer')*

*<span class="Apple-converted-space">  </span>\$development\_mode<span
class="Apple-converted-space">                      </span>=
hiera('wls\_development\_mode', true)*

*<span class="Apple-converted-space">  </span>\$adminserver\_address
<span class="Apple-converted-space">                  </span>=
hiera('adminserver\_address')*

*<span class="Apple-converted-space">  </span>\$adminserver\_port<span
class="Apple-converted-space">                      </span>=
hiera('adminserver\_port', '7001')*

*<span class="Apple-converted-space">  </span>\$java\_arguments<span
class="Apple-converted-space">                        </span>=
hiera('wls\_java\_arguments', {})*

*<span class="Apple-converted-space">  </span>\$jsse\_enabled<span
class="Apple-converted-space">                          </span>=
hiera('wls\_jsse\_enabled', true)*

*<span class="Apple-converted-space">  </span>\$nodemanager\_address
<span class="Apple-converted-space">                  </span>=
\$::ipaddress\_eth1*

*<span class="Apple-converted-space">  </span>\$nodemanager\_port<span
class="Apple-converted-space">                      </span>=
hiera('nodemanager\_port', '5556')*

*<span class="Apple-converted-space">  </span>\$weblogic\_user <span
class="Apple-converted-space">                        </span>=
hiera('wls\_weblogic\_user', 'weblogic')*

*<span class="Apple-converted-space">  </span>\$webtier\_enabled <span
class="Apple-converted-space">                      </span>= 'true'*

*<span class="Apple-converted-space">  </span>\$custom\_trust<span
class="Apple-converted-space">                          </span>=
hiera('wls\_custom\_trust', false)*

*<span class="Apple-converted-space">  </span>\$trust\_keystore\_file
<span class="Apple-converted-space">                  </span>=
hiera('wls\_trust\_keystore\_file' <span class="Apple-converted-space"> 
    </span>, undef)*

*<span class="Apple-converted-space"> 
</span>\$trust\_keystore\_passphrase <span
class="Apple-converted-space">            </span>=
hiera('wls\_trust\_keystore\_passphrase' , undef)*

*<span class="Apple-converted-space">  </span>\$custom\_identity <span
class="Apple-converted-space">                      </span>=
hiera('custom\_identity', false)*

*<span class="Apple-converted-space"> 
</span>\$custom\_identity\_keystore\_filename <span
class="Apple-converted-space">    </span>=
"\${source}/identity\_\${::hostname}.jks"*

*<span class="Apple-converted-space"> 
</span>\$custom\_identity\_keystore\_passphrase <span
class="Apple-converted-space">  </span>=
hiera('custom\_identity\_keystore\_passphrase', 'welcome')*

*<span class="Apple-converted-space">  </span>\$custom\_identity\_alias
<span class="Apple-converted-space">                </span>=
"\${::hostname}"*

*<span class="Apple-converted-space"> 
</span>\$custom\_identity\_privatekey\_passphrase =
hiera('custom\_identity\_privatekey\_passphrase', 'welcome')*

*<span class="Apple-converted-space">  </span>\$create\_rcu<span
class="Apple-converted-space">                            </span>=
hiera('create\_rcu', false)*

*<span class="Apple-converted-space">  </span>\$user\_config\_file<span
class="Apple-converted-space">                      </span>=
hiera('domain\_user\_config\_file',
"/home/webadmin/wls-Wls1036-WebLogicConfig.properties")*

*<span class="Apple-converted-space">  </span>\$user\_key\_file <span
class="Apple-converted-space">                        </span>=
hiera('domain\_user\_key\_file',
"/home/webadmin/wls-Wls1036-WebLogicKey.properties")*


*<span class="Apple-converted-space">  </span>case \$::osfamily {*

*<span class="Apple-converted-space">    </span>'RedHat': {*

*<span class="Apple-converted-space">      </span>\$wls\_filename <span
class="Apple-converted-space">            </span>=
hiera('wls\_filename', 'wls1036\_generic.jar')*

*<span class="Apple-converted-space">      </span>\$source <span
class="Apple-converted-space">                  </span>= hiera('source',
'/vagrant/oracle')*

*<span class="Apple-converted-space">    </span>}*

*<span class="Apple-converted-space">    </span>'AIX': {*

*<span class="Apple-converted-space">      </span>\$wls\_filename <span
class="Apple-converted-space">            </span>=
hiera('wls\_filename', 'wls1036\_generic.jar')*

*<span class="Apple-converted-space">      </span>\$source <span
class="Apple-converted-space">                  </span>= hiera('source',
'/vagrant/oracle')*

*<span class="Apple-converted-space">    </span>}*

*<span class="Apple-converted-space">    </span>default: {*

*<span class="Apple-converted-space">      </span>fail "Operating System
family \${::osfamily} not supported"*

*<span class="Apple-converted-space">    </span>}*

*<span class="Apple-converted-space">  </span>}*

*<span class="Apple-converted-space">  </span>case \$param\_lfg\_sysrole
{*

*<span class="Apple-converted-space">    </span>'wlsmgr': {*

*<span class="Apple-converted-space">      </span>\$wls\_role =
hiera('wls\_role', 'domainadmin')*

*<span class="Apple-converted-space">    </span>}*

*<span class="Apple-converted-space">    </span>'wls': {*

*<span class="Apple-converted-space">      </span>\$wls\_role =
hiera('wls\_role', 'nodemanager')*

*<span class="Apple-converted-space">    </span>}*

*<span class="Apple-converted-space">    </span>'ohs': {*

*<span class="Apple-converted-space">      </span>\$wls\_role =
hiera('wls\_role', 'ohs')*

*<span class="Apple-converted-space">    </span>}*

*<span class="Apple-converted-space">    </span>default: {*

*<span class="Apple-converted-space">      </span>fail "lfg\_sysrole is
not set correctly, possible values are \[wlsmgr, wls, ohs\],
\$::lfg\_sysrole"*

*<span class="Apple-converted-space">    </span>}*

*<span class="Apple-converted-space">  </span>}*

*}*

<span class="Apple-converted-space">  </span>The process of deploying a
new weblogic domain in the LFG infrastructure would be as follows:

1.<span class="Apple-converted-space">  </span>Create a domain yaml file
for hiera.<span class="Apple-converted-space">  </span>This will spell
out the extra feature enabled and configurations of those feature in
hash lists.<span class="Apple-converted-space">  </span>To enable
features not in the standard demo file please use the following
documentation https://github.com/biemond/biemond-orawls and listed in
the weblogic module resources.<span class="Apple-converted-space"> 
</span>To get a list of weblogic resources you can run 'puppet resource
–types | grep wls'.<span class="Apple-converted-space">  </span>To
explore any resource parameters you can run 'puppet describe
&lt;resource\_name&gt;'.

2.<span class="Apple-converted-space">  </span>Deploy the hosts with LFG
identified hostnaming convention.

3.<span class="Apple-converted-space">  </span>Deploy and or verify the
'wls\_domain' fact is correct and present.

4.<span class="Apple-converted-space">  </span>Allow puppet to run on
hosts 4-5 times, or run puppet on each host 4-5 times.<span
class="Apple-converted-space">  </span>This will need happen in a
domainadmin, nodemanager, ohs host order.

5.<span class="Apple-converted-space">  </span>Verify the hosts have
been configured correctly.


Each of these steps are required to be completed in this order.<span
class="Apple-converted-space">  </span>This code will not function
without the wls\_role being identified, which is done with the fact
lfg\_sysrole, or wls\_role in hiera, as well as wls\_domain being set.

