; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=armv8.1m.main -mattr=+mve -S -mve-tail-predication -tail-predication=enabled %s -o - | FileCheck %s

define void @mat_vec_sext_i16(ptr nocapture readonly %A, ptr nocapture readonly %B, ptr noalias nocapture %C, i32 %N) {
; CHECK-LABEL: @mat_vec_sext_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP24:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP24]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_COND1_PREHEADER_US_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader.us.preheader:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 3
; CHECK-NEXT:    [[N_VEC:%.*]] = and i32 [[N_RND_UP]], -4
; CHECK-NEXT:    [[TT:%.*]] = add i32 [[N_VEC]], -4
; CHECK-NEXT:    [[TT1:%.*]] = lshr i32 [[TT]], 2
; CHECK-NEXT:    [[TT2:%.*]] = add nuw nsw i32 [[TT1]], 1
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER_US:%.*]]
; CHECK:       for.cond1.preheader.us:
; CHECK-NEXT:    [[I_025_US:%.*]] = phi i32 [ [[INC10_US:%.*]], [[MIDDLE_BLOCK:%.*]] ], [ 0, [[FOR_COND1_PREHEADER_US_PREHEADER]] ]
; CHECK-NEXT:    [[ARRAYIDX_US:%.*]] = getelementptr inbounds ptr, ptr [[A:%.*]], i32 [[I_025_US]]
; CHECK-NEXT:    [[TT3:%.*]] = load ptr, ptr [[ARRAYIDX_US]], align 4
; CHECK-NEXT:    [[ARRAYIDX8_US:%.*]] = getelementptr inbounds i32, ptr [[C:%.*]], i32 [[I_025_US]]
; CHECK-NEXT:    [[ARRAYIDX8_PROMOTED_US:%.*]] = load i32, ptr [[ARRAYIDX8_US]], align 4
; CHECK-NEXT:    [[TT4:%.*]] = insertelement <4 x i32> <i32 undef, i32 0, i32 0, i32 0>, i32 [[ARRAYIDX8_PROMOTED_US]], i32 0
; CHECK-NEXT:    [[START:%.*]] = call i32 @llvm.start.loop.iterations.i32(i32 [[TT2]])
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[FOR_COND1_PREHEADER_US]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ [[TT4]], [[FOR_COND1_PREHEADER_US]] ], [ [[TT14:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TT5:%.*]] = phi i32 [ [[START]], [[FOR_COND1_PREHEADER_US]] ], [ [[TT15:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = phi i32 [ [[N]], [[FOR_COND1_PREHEADER_US]] ], [ [[TMP2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TT6:%.*]] = getelementptr inbounds i16, ptr [[TT3]], i32 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.vctp32(i32 [[TMP0]])
; CHECK-NEXT:    [[TMP2]] = sub i32 [[TMP0]], 4
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i16> @llvm.masked.load.v4i16.p0(ptr [[TT6]], i32 2, <4 x i1> [[TMP1]], <4 x i16> undef)
; CHECK-NEXT:    [[TT9:%.*]] = sext <4 x i16> [[WIDE_MASKED_LOAD]] to <4 x i32>
; CHECK-NEXT:    [[TT10:%.*]] = getelementptr inbounds i16, ptr [[B:%.*]], i32 [[INDEX]]
; CHECK-NEXT:    [[WIDE_MASKED_LOAD30:%.*]] = call <4 x i16> @llvm.masked.load.v4i16.p0(ptr [[TT10]], i32 2, <4 x i1> [[TMP1]], <4 x i16> undef)
; CHECK-NEXT:    [[TT12:%.*]] = sext <4 x i16> [[WIDE_MASKED_LOAD30]] to <4 x i32>
; CHECK-NEXT:    [[TT13:%.*]] = mul nsw <4 x i32> [[TT12]], [[TT9]]
; CHECK-NEXT:    [[TT14]] = add nsw <4 x i32> [[TT13]], [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TT15]] = call i32 @llvm.loop.decrement.reg.i32(i32 [[TT5]], i32 1)
; CHECK-NEXT:    [[TT16:%.*]] = icmp ne i32 [[TT15]], 0
; CHECK-NEXT:    br i1 [[TT16]], label [[VECTOR_BODY]], label [[MIDDLE_BLOCK]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TT17:%.*]] = select <4 x i1> [[TMP1]], <4 x i32> [[TT14]], <4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[TT18:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[TT17]])
; CHECK-NEXT:    store i32 [[TT18]], ptr [[ARRAYIDX8_US]], align 4
; CHECK-NEXT:    [[INC10_US]] = add nuw i32 [[I_025_US]], 1
; CHECK-NEXT:    [[EXITCOND27:%.*]] = icmp eq i32 [[INC10_US]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND27]], label [[FOR_COND_CLEANUP]], label [[FOR_COND1_PREHEADER_US]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
;
entry:
  %cmp24 = icmp eq i32 %N, 0
  br i1 %cmp24, label %for.cond.cleanup, label %for.cond1.preheader.us.preheader

for.cond1.preheader.us.preheader:                 ; preds = %entry
  %n.rnd.up = add i32 %N, 3
  %n.vec = and i32 %n.rnd.up, -4
  %tt = add i32 %n.vec, -4
  %tt1 = lshr i32 %tt, 2
  %tt2 = add nuw nsw i32 %tt1, 1
  br label %for.cond1.preheader.us

for.cond1.preheader.us:                           ; preds = %middle.block, %for.cond1.preheader.us.preheader
  %i.025.us = phi i32 [ %inc10.us, %middle.block ], [ 0, %for.cond1.preheader.us.preheader ]
  %arrayidx.us = getelementptr inbounds ptr, ptr %A, i32 %i.025.us
  %tt3 = load ptr, ptr %arrayidx.us, align 4
  %arrayidx8.us = getelementptr inbounds i32, ptr %C, i32 %i.025.us
  %arrayidx8.promoted.us = load i32, ptr %arrayidx8.us, align 4
  %tt4 = insertelement <4 x i32> <i32 undef, i32 0, i32 0, i32 0>, i32 %arrayidx8.promoted.us, i32 0
  %start = call i32 @llvm.start.loop.iterations.i32(i32 %tt2)
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %for.cond1.preheader.us
  %index = phi i32 [ 0, %for.cond1.preheader.us ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ %tt4, %for.cond1.preheader.us ], [ %tt14, %vector.body ]
  %tt5 = phi i32 [ %start, %for.cond1.preheader.us ], [ %tt15, %vector.body ]
  %tt6 = getelementptr inbounds i16, ptr %tt3, i32 %index
  %tt7 = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %N)
  %wide.masked.load = call <4 x i16> @llvm.masked.load.v4i16.p0(ptr %tt6, i32 2, <4 x i1> %tt7, <4 x i16> undef)
  %tt9 = sext <4 x i16> %wide.masked.load to <4 x i32>
  %tt10 = getelementptr inbounds i16, ptr %B, i32 %index
  %wide.masked.load30 = call <4 x i16> @llvm.masked.load.v4i16.p0(ptr %tt10, i32 2, <4 x i1> %tt7, <4 x i16> undef)
  %tt12 = sext <4 x i16> %wide.masked.load30 to <4 x i32>
  %tt13 = mul nsw <4 x i32> %tt12, %tt9
  %tt14 = add nsw <4 x i32> %tt13, %vec.phi
  %index.next = add i32 %index, 4
  %tt15 = call i32 @llvm.loop.decrement.reg.i32(i32 %tt5, i32 1)
  %tt16 = icmp ne i32 %tt15, 0
  br i1 %tt16, label %vector.body, label %middle.block

middle.block:                                     ; preds = %vector.body
  %tt17 = select <4 x i1> %tt7, <4 x i32> %tt14, <4 x i32> %vec.phi
  %tt18 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %tt17)
  store i32 %tt18, ptr %arrayidx8.us, align 4
  %inc10.us = add nuw i32 %i.025.us, 1
  %exitcond27 = icmp eq i32 %inc10.us, %N
  br i1 %exitcond27, label %for.cond.cleanup, label %for.cond1.preheader.us

for.cond.cleanup:                                 ; preds = %middle.block, %entry
  ret void
}

define void @mat_vec_i32(ptr nocapture readonly %A, ptr nocapture readonly %B, ptr noalias nocapture %C, i32 %N) {
; CHECK-LABEL: @mat_vec_i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP23:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP23]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_COND1_PREHEADER_US_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader.us.preheader:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N]], 3
; CHECK-NEXT:    [[N_VEC:%.*]] = and i32 [[N_RND_UP]], -4
; CHECK-NEXT:    [[TT:%.*]] = add i32 [[N_VEC]], -4
; CHECK-NEXT:    [[TT1:%.*]] = lshr i32 [[TT]], 2
; CHECK-NEXT:    [[TT2:%.*]] = add nuw nsw i32 [[TT1]], 1
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER_US:%.*]]
; CHECK:       for.cond1.preheader.us:
; CHECK-NEXT:    [[I_024_US:%.*]] = phi i32 [ [[INC9_US:%.*]], [[MIDDLE_BLOCK:%.*]] ], [ 0, [[FOR_COND1_PREHEADER_US_PREHEADER]] ]
; CHECK-NEXT:    [[ARRAYIDX_US:%.*]] = getelementptr inbounds ptr, ptr [[A:%.*]], i32 [[I_024_US]]
; CHECK-NEXT:    [[TT3:%.*]] = load ptr, ptr [[ARRAYIDX_US]], align 4
; CHECK-NEXT:    [[ARRAYIDX7_US:%.*]] = getelementptr inbounds i32, ptr [[C:%.*]], i32 [[I_024_US]]
; CHECK-NEXT:    [[ARRAYIDX7_PROMOTED_US:%.*]] = load i32, ptr [[ARRAYIDX7_US]], align 4
; CHECK-NEXT:    [[TT4:%.*]] = insertelement <4 x i32> <i32 undef, i32 0, i32 0, i32 0>, i32 [[ARRAYIDX7_PROMOTED_US]], i32 0
; CHECK-NEXT:    [[START:%.*]] = call i32 @llvm.start.loop.iterations.i32(i32 [[TT2]])
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[FOR_COND1_PREHEADER_US]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ [[TT4]], [[FOR_COND1_PREHEADER_US]] ], [ [[TT12:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TT5:%.*]] = phi i32 [ [[START]], [[FOR_COND1_PREHEADER_US]] ], [ [[TT13:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = phi i32 [ [[N]], [[FOR_COND1_PREHEADER_US]] ], [ [[TMP2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TT6:%.*]] = getelementptr inbounds i32, ptr [[TT3]], i32 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.vctp32(i32 [[TMP0]])
; CHECK-NEXT:    [[TMP2]] = sub i32 [[TMP0]], 4
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr [[TT6]], i32 4, <4 x i1> [[TMP1]], <4 x i32> undef)
; CHECK-NEXT:    [[TT9:%.*]] = getelementptr inbounds i32, ptr [[B:%.*]], i32 [[INDEX]]
; CHECK-NEXT:    [[WIDE_MASKED_LOAD29:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr [[TT9]], i32 4, <4 x i1> [[TMP1]], <4 x i32> undef)
; CHECK-NEXT:    [[TT11:%.*]] = mul nsw <4 x i32> [[WIDE_MASKED_LOAD29]], [[WIDE_MASKED_LOAD]]
; CHECK-NEXT:    [[TT12]] = add nsw <4 x i32> [[VEC_PHI]], [[TT11]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TT13]] = call i32 @llvm.loop.decrement.reg.i32(i32 [[TT5]], i32 1)
; CHECK-NEXT:    [[TT14:%.*]] = icmp ne i32 [[TT13]], 0
; CHECK-NEXT:    br i1 [[TT14]], label [[VECTOR_BODY]], label [[MIDDLE_BLOCK]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TT15:%.*]] = select <4 x i1> [[TMP1]], <4 x i32> [[TT12]], <4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[TT16:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[TT15]])
; CHECK-NEXT:    store i32 [[TT16]], ptr [[ARRAYIDX7_US]], align 4
; CHECK-NEXT:    [[INC9_US]] = add nuw i32 [[I_024_US]], 1
; CHECK-NEXT:    [[EXITCOND26:%.*]] = icmp eq i32 [[INC9_US]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND26]], label [[FOR_COND_CLEANUP]], label [[FOR_COND1_PREHEADER_US]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
;
entry:
  %cmp23 = icmp eq i32 %N, 0
  br i1 %cmp23, label %for.cond.cleanup, label %for.cond1.preheader.us.preheader

for.cond1.preheader.us.preheader:                 ; preds = %entry
  %n.rnd.up = add i32 %N, 3
  %n.vec = and i32 %n.rnd.up, -4
  %tt = add i32 %n.vec, -4
  %tt1 = lshr i32 %tt, 2
  %tt2 = add nuw nsw i32 %tt1, 1
  br label %for.cond1.preheader.us

for.cond1.preheader.us:                           ; preds = %middle.block, %for.cond1.preheader.us.preheader
  %i.024.us = phi i32 [ %inc9.us, %middle.block ], [ 0, %for.cond1.preheader.us.preheader ]
  %arrayidx.us = getelementptr inbounds ptr, ptr %A, i32 %i.024.us
  %tt3 = load ptr, ptr %arrayidx.us, align 4
  %arrayidx7.us = getelementptr inbounds i32, ptr %C, i32 %i.024.us
  %arrayidx7.promoted.us = load i32, ptr %arrayidx7.us, align 4
  %tt4 = insertelement <4 x i32> <i32 undef, i32 0, i32 0, i32 0>, i32 %arrayidx7.promoted.us, i32 0
  %start = call i32 @llvm.start.loop.iterations.i32(i32 %tt2)
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %for.cond1.preheader.us
  %index = phi i32 [ 0, %for.cond1.preheader.us ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ %tt4, %for.cond1.preheader.us ], [ %tt12, %vector.body ]
  %tt5 = phi i32 [ %start, %for.cond1.preheader.us ], [ %tt13, %vector.body ]
  %tt6 = getelementptr inbounds i32, ptr %tt3, i32 %index
  %tt7 = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %N)
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %tt6, i32 4, <4 x i1> %tt7, <4 x i32> undef)
  %tt9 = getelementptr inbounds i32, ptr %B, i32 %index
  %wide.masked.load29 = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %tt9, i32 4, <4 x i1> %tt7, <4 x i32> undef)
  %tt11 = mul nsw <4 x i32> %wide.masked.load29, %wide.masked.load
  %tt12 = add nsw <4 x i32> %vec.phi, %tt11
  %index.next = add i32 %index, 4
  %tt13 = call i32 @llvm.loop.decrement.reg.i32(i32 %tt5, i32 1)
  %tt14 = icmp ne i32 %tt13, 0
  br i1 %tt14, label %vector.body, label %middle.block

middle.block:                                     ; preds = %vector.body
  %tt15 = select <4 x i1> %tt7, <4 x i32> %tt12, <4 x i32> %vec.phi
  %tt16 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %tt15)
  store i32 %tt16, ptr %arrayidx7.us, align 4
  %inc9.us = add nuw i32 %i.024.us, 1
  %exitcond26 = icmp eq i32 %inc9.us, %N
  br i1 %exitcond26, label %for.cond.cleanup, label %for.cond1.preheader.us

for.cond.cleanup:                                 ; preds = %middle.block, %entry
  ret void
}


; Function Attrs: argmemonly nounwind readonly willreturn
declare <4 x i32> @llvm.masked.load.v4i32.p0(ptr, i32 immarg, <4 x i1>, <4 x i32>) #0

; Function Attrs: argmemonly nounwind readonly willreturn
declare <4 x i16> @llvm.masked.load.v4i16.p0(ptr, i32 immarg, <4 x i1>, <4 x i16>) #0

; Function Attrs: nounwind readnone willreturn
declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>) #1

; Function Attrs: noduplicate nounwind
declare i32 @llvm.start.loop.iterations.i32(i32) #2

; Function Attrs: noduplicate nounwind
declare i32 @llvm.loop.decrement.reg.i32(i32, i32) #2

declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)

attributes #0 = { argmemonly nounwind readonly willreturn }
attributes #1 = { nounwind readnone willreturn }
attributes #2 = { noduplicate nounwind }