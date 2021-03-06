(*
 * Copyright 2014, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(NICTA_GPL)
 *)
(*<*)
(* THIS FILE IS AUTOMATICALLY GENERATED. YOUR EDITS WILL BE OVERWRITTEN. *)
theory GenSimpleSystem
imports UserSimple
begin
(*>*)

subsection \<open>\label{ssec:procsys}Generated System Theory\<close>

subsubsection \<open>\label{sssec:procsystypes}Types\<close>
text \<open>
  At the system level, type instantiations are provided for components and
  local and global state. These are derived by simply instantiating the
  relevant types with the types generated in the base theory. Note that
  the @{term component_state} type is expected to be provided by the user in
  their intermediate theory.
\<close>

type_synonym component = "(channel, component_state) comp"

type_synonym lstate = "component_state local_state"

type_synonym gstate = "(inst, channel, component_state) global_state"

subsubsection \<open>\label{ssec:procsysuntrusted}Untrusted Components\<close>
text \<open>
  For each component type, a definition is generated that describes its
  execution without specifying the behaviour of any user-provided code. These
  definitions allow the component to perform any manipulation of its local
  state or to send or receive any message on the interfaces available to it.
  These definitions are intended for use in a system composition when the
  behaviour of a specific component is not relevant to the desirable property
  of the whole system.
  These definitions are more general than the implementation allows, in that
  they permit an untrusted component to perform actions such as sending on an
  incoming interface which may not be possible in the implementation.

  Recall from \autoref{h:userstubs} that the user is expected to provide a
  mapping describing trusted components in their intermediate theory. A
  definition of untrusted execution for each component is generated regardless
  of whether all instances of that component in the current system have trusted
  specifications or not.
\<close>

definition
  Client_untrusted :: "(Client_channel \<Rightarrow> channel) \<Rightarrow> component"
where
  "Client_untrusted ch \<equiv>
    LOOP (
      UserStep
    \<squnion> ArbitraryRequest (ch Client_s)
    \<squnion> ArbitraryResponse (ch Client_s))"

definition
  Echo_untrusted :: "(Echo_channel \<Rightarrow> channel) \<Rightarrow> component"
where
  "Echo_untrusted ch \<equiv>
    LOOP (
      UserStep
    \<squnion> ArbitraryRequest (ch Echo_s)
    \<squnion> ArbitraryResponse (ch Echo_s))"

subsubsection \<open>\label{ssec:procsysinst}Component Instances\<close>
text \<open>
  As was the case for the instantiation of primitives in
  \autoref{sssec:procbaseinst}, with the definition of an untrusted component's
  execution generated previously, a definition of the execution of an untrusted
  instance can be formed by partially applying the component definition. A
  definition of untrusted execution is generated for each component instance,
  whether it is required or not.
\<close>

definition
  client_untrusted :: component
where
  "client_untrusted \<equiv> Client_untrusted (\<lambda>c. case c of Client_s \<Rightarrow> simple)"

definition
  echo_untrusted :: component
where
  "echo_untrusted \<equiv> Echo_untrusted (\<lambda>c. case c of Echo_s \<Rightarrow> simple)"

subsubsection \<open>\label{sssec:procsysgs}Initial State\<close>
text \<open>
  The final generated definition is the initial state of the system. Following
  the type instantiations in \autoref{sssec:procsystypes}, the initial global
  state is
  a mapping from component instance names to a pair of their program text and
  local state. The generated definition looks for the instance's definition in
  the (user-provided) mapping of trusted instances and, if it does not find
  this, falls back on the generated untrusted definitions.
\<close>

definition
  gs\<^sub>0 :: gstate
where
  "gs\<^sub>0 p \<equiv> case trusted p of Some s \<Rightarrow> Some s | _ \<Rightarrow>
  (case p of client \<Rightarrow> Some (client_untrusted, Component init_component_state)
           | echo \<Rightarrow> Some (echo_untrusted, Component init_component_state))"

(*<*)
end
(*>*)
