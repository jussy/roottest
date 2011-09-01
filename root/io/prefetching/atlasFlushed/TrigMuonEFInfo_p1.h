//////////////////////////////////////////////////////////
//   This class has been generated by TFile::MakeProject
//     (Tue Jun 14 15:33:00 2011 by ROOT version 5.31/01)
//      from the StreamerInfo in file http://root.cern.ch/files/atlasFlushed.root
//////////////////////////////////////////////////////////


#ifndef TrigMuonEFInfo_p1_h
#define TrigMuonEFInfo_p1_h
class TrigMuonEFInfo_p1;

#include "TPObjRef.h"

class TrigMuonEFInfo_p1 {

public:
// Nested classes declaration.

public:
// Data Members.
   unsigned short m_roi;       //
   TPObjRef       m_spectrometerTrack;    //
   TPObjRef       m_extrapolatedTrack;    //
   TPObjRef       m_combinedTrack;        //

   TrigMuonEFInfo_p1();
   TrigMuonEFInfo_p1(const TrigMuonEFInfo_p1 & );
   virtual ~TrigMuonEFInfo_p1();

};
#endif