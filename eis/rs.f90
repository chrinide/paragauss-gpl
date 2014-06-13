!
! DIE FOLGENDEN ROUTINEN STAMMEN AUS DEN EISPACK-QUELLEN
!
! DES LEIBNITZ-RECHENZENTRUMS IN MUENCHEN
!
! [ RS, RSG, CH, ...
!
!   REDUC, TRED1, TRED2, HTRIDI, TQLRAT, TQL2, REBAK, HTRIBK, ...
!
!   PYTHAG, EPSLON ]
!
! ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
      SUBROUTINE RS(NM,N,A,W,MATZ,Z,FV1,FV2,IERR)
        use type_module
        implicit real(kind=r8_kind) (a-h,o-z)
!
      INTEGER(kind=i4_kind) N,NM,IERR,MATZ
      real(kind=r8_kind) A(NM,N),W(N),Z(NM,N),FV1(N),FV2(N) !forpcXS
!
!     THIS SUBROUTINE CALLS THE RECOMMENDED SEQUENCE OF
!     SUBROUTINES FROM THE EIGENSYSTEM SUBROUTINE PACKAGE (EISPACK)
!     TO FIND THE EIGENVALUES AND EIGENVECTORS (IF DESIRED)
!     OF A REAL SYMMETRIC MATRIX.
!
!     ON INPUT
!
!        NM  MUST BE SET TO THE ROW DIMENSION OF THE TWO-DIMENSIONAL
!        ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!        DIMENSION STATEMENT.
!
!        N  IS THE ORDER OF THE MATRIX  A.
!
!        A  CONTAINS THE REAL SYMMETRIC MATRIX.
!
!        MATZ  IS AN INTEGER VARIABLE SET EQUAL TO ZERO IF
!        ONLY EIGENVALUES ARE DESIRED.  OTHERWISE IT IS SET TO
!        ANY NON-ZERO INTEGER FOR BOTH EIGENVALUES AND EIGENVECTORS.
!
!     ON OUTPUT
!
!        W  CONTAINS THE EIGENVALUES IN ASCENDING ORDER.
!
!        Z  CONTAINS THE EIGENVECTORS IF MATZ IS NOT ZERO.
!
!        IERR  IS AN INTEGER OUTPUT VARIABLE SET EQUAL TO AN ERROR
!           COMPLETION CODE DESCRIBED IN THE DOCUMENTATION FOR TQLRAT
!           AND TQL2.  THE NORMAL COMPLETION CODE IS ZERO.
!
!        FV1  AND  FV2  ARE TEMPORARY STORAGE ARRAYS.
!
!     QUESTIONS AND COMMENTS SHOULD BE DIRECTED TO BURTON S. GARBOW,
!     MATHEMATICS AND COMPUTER SCIENCE DIV, ARGONNE NATIONAL LABORATORY
!
!     THIS VERSION DATED AUGUST 1983.
!
!     ------------------------------------------------------------------
!
      IF (N .LE. NM) GO TO 10
      IERR = 10 * N
      GO TO 50
!
   10 IF (MATZ .NE. 0) GO TO 20
!     .......... FIND EIGENVALUES ONLY ..........
      CALL  TRED1(NM,N,A,W,FV1,FV2)
      CALL  TQLRAT(N,W,FV2,IERR)
      GO TO 50
!     .......... FIND BOTH EIGENVALUES AND EIGENVECTORS ..........
   20 CALL  TRED2(NM,N,A,W,FV1,Z)
      CALL  TQL2(NM,N,W,FV1,Z,IERR)
   50 RETURN
      END
