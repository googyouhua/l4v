(*
 * Copyright 2019, Data61, CSIRO
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(DATA61_GPL)
 *)

theory ArchBCorres_AI
imports
  "../BCorres_AI"
begin

context Arch begin global_naming RISCV64

lemma vspace_for_asid_truncate[simp]:
  "vspace_for_asid asid (truncate_state s) = vspace_for_asid asid s"
  by (simp add: vspace_for_asid_def pool_for_asid_def obind_def oassert_def oreturn_def swp_def
         split: option.splits)

lemma pool_for_asid_truncate[simp]:
  "pool_for_asid asid (truncate_state s) = pool_for_asid asid s"
  by (simp add: pool_for_asid_def)

lemma vs_lookup_table_truncate[simp]:
  "vs_lookup_table l asid vptr (truncate_state s) = vs_lookup_table l asid vptr s"
  by (simp add: vs_lookup_table_def obind_def oreturn_def split: option.splits)

lemma vs_lookup_slot_truncate[simp]:
  "vs_lookup_slot l asid vptr (truncate_state s) = vs_lookup_slot l asid vptr s"
  by (simp add: vs_lookup_slot_def obind_def oreturn_def split: option.splits)

lemma pt_lookup_from_level_bcorres[wp]:
  "bcorres (pt_lookup_from_level l r b c) (pt_lookup_from_level l r b c)"
  by (induct l arbitrary: r b c rule: bit0.minus_induct; wpsimp simp: pt_lookup_from_level_simps)

crunch (bcorres) bcorres[wp]: arch_finalise_cap truncate_state
crunch (bcorres) bcorres[wp]: prepare_thread_delete truncate_state

end

requalify_facts RISCV64.arch_finalise_cap_bcorres RISCV64.prepare_thread_delete_bcorres

declare arch_finalise_cap_bcorres[wp] prepare_thread_delete_bcorres[wp]

end
