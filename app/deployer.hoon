/+  default-agent
^-  agent:gall
=|  state=[api-key=@t webhook-secret=@t current-commit=@t]
|_  =bowl:gall
+*  this      .
    default   ~(. (default-agent this %|) bowl)
::
++  on-init
  :_  this
  [%pass /bind-deployer %arvo %e %connect `/'deployer' %deployer]~
++  on-save   !>(state)
++  on-load
  |=  old-state=vase
  ~&  old-state
  `this(state !<([@ @ @] old-state))
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  ~&  state
  ?+  mark  (on-poke:default [mark vase])
    %noun
  ?>  ?=([@ @ @] q.vase)
  =.  state  q.vase
  `this
    %handle-http-request
  =/  req  !<  (pair @ta inbound-request:eyre)  vase
  ?>  ?=(%'POST' method.request.q.req)
  ?~  header-list.request.q.req  !!
  ?~  body.request.q.req  !!
  =/  sig
    %+  rash
      %^  cut  3  [7 64]
      %-  ~(got by (malt header-list.request.q.req))
      'x-hub-signature-256'
    hex
  ?.  =(sig (hmac-sha256t:hmac:crypto webhook-secret.state q.u.body.request.q.req))  !!

  =/  jsn  (need (de-json:html q.u.body.request.q.req))
  ?>  ?=(%o -.jsn)
  =/  ref  (~(got by p.jsn) 'ref')
  ?>  ?=(%s -.ref)
  =/  commit  (~(got by p.jsn) 'after')
  ?>  ?=(%s -.commit)
  :_  this
  %+  weld
  ^-  (list card:agent:gall)
  :~  [%give %fact [/http-response/[p.req]]~ %http-response-header !>([204 ~])]
      [%give %fact [/http-response/[p.req]]~ %http-response-data !>(~)]
      [%give %kick [/http-response/[p.req]]~ ~]
  ==
  ?:  =('refs/heads/develop' p.ref)
    ^-  (list card:agent:gall)
    [%pass /commit %arvo %k %fard q.byk.bowl %deployer %noun !>([api-key.state current-commit.state p.commit])]~
    ~
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?+  wire  (on-arvo:default [wire sign-arvo])
    [%commit ~]
  ?>  ?=([%khan %arow *] sign-arvo)
  ?:  ?=(%.n -.p.sign-arvo)
    ((slog leaf+<p.p.sign-arvo> ~) `this)
  =+  !<([commit=@t kids=@uv] q.p.p.sign-arvo)
  ~&  [%commit commit]
  ~&  [%kids kids]
::  =.  current-commit.state  commit
  `this(current-commit.state commit)
    [%bind-deployer ~]
  ?>  ?=([%eyre %bound *] sign-arvo)
  ?:  accepted.sign-arvo
    %-  (slog leaf+"/deployer bound successfully!" ~)
    `this
  %-  (slog leaf+"binding /deployer failed!" ~)
  `this
  ==
++  on-watch
  |=  =path
  ^-  (quip card:agent:gall _this)
  ?+    path
    (on-watch:default path)
  ::
      [%http-response *]
    %-  (slog leaf+"eyre subscribed to {(spud path)}." ~)
    `this
  ==
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
++  on-leave  on-leave:default
--
