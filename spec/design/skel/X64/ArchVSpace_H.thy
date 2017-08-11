(*
 * Copyright 2014, General Dynamics C4 Systems
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(GD_GPL)
 *)

(*
  VSpace lookup code.
*)

theory ArchVSpace_H
imports
  "../CNode_H"
  "../Untyped_H"
  "../KI_Decls_H"
  ArchVSpaceDecls_H
begin

context Arch begin global_naming X64_H

#INCLUDE_HASKELL SEL4/Kernel/VSpace/X64.lhs CONTEXT X64_H bodies_only ArchInv=ArchRetypeDecls_H NOT checkPML4At checkPDPTAt checkPDAt checkPTAt checkPML4ASIDMapMembership checkValidMappingSize asidInvalidate
#INCLUDE_HASKELL SEL4/Object/IOPort/X64.lhs CONTEXT X64_H bodies_only ArchInv=ArchRetypeDecls_H

defs checkValidMappingSize_def:
  "checkValidMappingSize sz \<equiv> stateAssert
    (\<lambda>s. 2 ^ pageBitsForSize sz <= gsMaxObjectSize s) []"

end

end
