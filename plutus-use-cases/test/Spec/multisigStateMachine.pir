(program
  (let
    (nonrec)
    (datatypebind
      (datatype
        (tyvardecl Tuple2 (fun (type) (fun (type) (type))))
        (tyvardecl a (type)) (tyvardecl b (type))
        Tuple2_match
        (vardecl Tuple2 (fun a (fun b [[Tuple2 a] b])))
      )
    )
    (let
      (rec)
      (datatypebind
        (datatype
          (tyvardecl List (fun (type) (type)))
          (tyvardecl a (type))
          Nil_match
          (vardecl Nil [List a]) (vardecl Cons (fun a (fun [List a] [List a])))
        )
      )
      (let
        (nonrec)
        (datatypebind
          (datatype (tyvardecl Unit (type))  Unit_match (vardecl Unit Unit))
        )
        (datatypebind
          (datatype
            (tyvardecl Bool (type))

            Bool_match
            (vardecl True Bool) (vardecl False Bool)
          )
        )
        (datatypebind
          (datatype
            (tyvardecl These (fun (type) (fun (type) (type))))
            (tyvardecl a (type)) (tyvardecl b (type))
            These_match
            (vardecl That (fun b [[These a] b]))
            (vardecl These (fun a (fun b [[These a] b])))
            (vardecl This (fun a [[These a] b]))
          )
        )
        (termbind
          (strict)
          (vardecl
            fToDataBuiltinByteString_ctoBuiltinData
            (fun (con bytestring) (con data))
          )
          (lam b (con bytestring) [ (builtin bData) b ])
        )
        (termbind
          (strict)
          (vardecl fToDataInteger_ctoBuiltinData (fun (con integer) (con data)))
          (lam i (con integer) [ (builtin iData) i ])
        )
        (termbind
          (strict)
          (vardecl
            fToDataTuple2_ctoBuiltinData
            (all a (type) (all b (type) (fun [(lam a (type) (fun a (con data))) a] (fun [(lam a (type) (fun a (con data))) b] (fun [[Tuple2 a] b] (con data))))))
          )
          (abs
            a
            (type)
            (abs
              b
              (type)
              (lam
                dToData
                [(lam a (type) (fun a (con data))) a]
                (lam
                  dToData
                  [(lam a (type) (fun a (con data))) b]
                  (lam
                    ds
                    [[Tuple2 a] b]
                    [
                      { [ { { Tuple2_match a } b } ds ] (con data) }
                      (lam
                        arg
                        a
                        (lam
                          arg
                          b
                          [
                            [ (builtin constrData) (con integer 0) ]
                            [
                              [
                                { (builtin mkCons) (con data) } [ dToData arg ]
                              ]
                              [
                                [
                                  { (builtin mkCons) (con data) }
                                  [ dToData arg ]
                                ]
                                [ (builtin mkNilData) (con unit ()) ]
                              ]
                            ]
                          ]
                        )
                      )
                    ]
                  )
                )
              )
            )
          )
        )
        (termbind
          (nonstrict)
          (vardecl fToDataMap [(con list) (con data)])
          [ (builtin mkNilData) (con unit ()) ]
        )
        (termbind
          (strict)
          (vardecl
            fToDataMap_ctoBuiltinData
            (all k (type) (all v (type) (fun [(lam a (type) (fun a (con data))) k] (fun [(lam a (type) (fun a (con data))) v] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) k] v] (con data))))))
          )
          (abs
            k
            (type)
            (abs
              v
              (type)
              (lam
                dToData
                [(lam a (type) (fun a (con data))) k]
                (lam
                  dToData
                  [(lam a (type) (fun a (con data))) v]
                  (lam
                    eta
                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) k] v]
                    (let
                      (rec)
                      (termbind
                        (strict)
                        (vardecl
                          go (fun [List [[Tuple2 k] v]] [(con list) (con data)])
                        )
                        (lam
                          ds
                          [List [[Tuple2 k] v]]
                          [
                            [
                              [
                                {
                                  [ { Nil_match [[Tuple2 k] v] } ds ]
                                  (fun Unit [(con list) (con data)])
                                }
                                (lam thunk Unit fToDataMap)
                              ]
                              (lam
                                x
                                [[Tuple2 k] v]
                                (lam
                                  xs
                                  [List [[Tuple2 k] v]]
                                  (lam
                                    thunk
                                    Unit
                                    [
                                      [
                                        { (builtin mkCons) (con data) }
                                        [
                                          [
                                            [
                                              {
                                                {
                                                  fToDataTuple2_ctoBuiltinData k
                                                }
                                                v
                                              }
                                              dToData
                                            ]
                                            dToData
                                          ]
                                          x
                                        ]
                                      ]
                                      [ go xs ]
                                    ]
                                  )
                                )
                              )
                            ]
                            Unit
                          ]
                        )
                      )
                      [ (builtin listData) [ go eta ] ]
                    )
                  )
                )
              )
            )
          )
        )
        (termbind
          (nonstrict)
          (vardecl
            fToDataValue
            (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)] (con data))
          )
          [
            [
              { { fToDataMap_ctoBuiltinData (con bytestring) } (con integer) }
              fToDataBuiltinByteString_ctoBuiltinData
            ]
            fToDataInteger_ctoBuiltinData
          ]
        )
        (datatypebind
          (datatype
            (tyvardecl Payment (type))

            Payment_match
            (vardecl
              Payment
              (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun (con bytestring) (fun (con integer) Payment)))
            )
          )
        )
        (termbind
          (strict)
          (vardecl fToDataInput_ctoBuiltinData (fun Payment (con data)))
          (lam
            ds
            Payment
            [
              { [ Payment_match ds ] (con data) }
              (lam
                arg
                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                (lam
                  arg
                  (con bytestring)
                  (lam
                    arg
                    (con integer)
                    [
                      [ (builtin constrData) (con integer 0) ]
                      [
                        [
                          { (builtin mkCons) (con data) }
                          [
                            [
                              [
                                {
                                  { fToDataMap_ctoBuiltinData (con bytestring) }
                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                }
                                fToDataBuiltinByteString_ctoBuiltinData
                              ]
                              fToDataValue
                            ]
                            arg
                          ]
                        ]
                        [
                          [
                            { (builtin mkCons) (con data) }
                            [ (builtin bData) arg ]
                          ]
                          [
                            [
                              { (builtin mkCons) (con data) }
                              [ (builtin iData) arg ]
                            ]
                            [ (builtin mkNilData) (con unit ()) ]
                          ]
                        ]
                      ]
                    ]
                  )
                )
              )
            ]
          )
        )
        (datatypebind
          (datatype
            (tyvardecl MSState (type))

            MSState_match
            (vardecl
              CollectingSignatures
              (fun Payment (fun [List (con bytestring)] MSState))
            )
            (vardecl Holding MSState)
          )
        )
        (termbind
          (strict)
          (vardecl fToDataMSState_ctoBuiltinData (fun MSState (con data)))
          (lam
            ds
            MSState
            [
              [
                [
                  { [ MSState_match ds ] (fun Unit (con data)) }
                  (lam
                    arg
                    Payment
                    (lam
                      arg
                      [List (con bytestring)]
                      (lam
                        thunk
                        Unit
                        (let
                          (rec)
                          (termbind
                            (strict)
                            (vardecl
                              go
                              (fun [List (con bytestring)] [(con list) (con data)])
                            )
                            (lam
                              ds
                              [List (con bytestring)]
                              [
                                [
                                  [
                                    {
                                      [ { Nil_match (con bytestring) } ds ]
                                      (fun Unit [(con list) (con data)])
                                    }
                                    (lam
                                      thunk
                                      Unit
                                      [ (builtin mkNilData) (con unit ()) ]
                                    )
                                  ]
                                  (lam
                                    x
                                    (con bytestring)
                                    (lam
                                      xs
                                      [List (con bytestring)]
                                      (lam
                                        thunk
                                        Unit
                                        [
                                          [
                                            { (builtin mkCons) (con data) }
                                            [ (builtin bData) x ]
                                          ]
                                          [ go xs ]
                                        ]
                                      )
                                    )
                                  )
                                ]
                                Unit
                              ]
                            )
                          )
                          [
                            [ (builtin constrData) (con integer 1) ]
                            [
                              [
                                { (builtin mkCons) (con data) }
                                [ fToDataInput_ctoBuiltinData arg ]
                              ]
                              [
                                [
                                  { (builtin mkCons) (con data) }
                                  [ (builtin listData) [ go arg ] ]
                                ]
                                [ (builtin mkNilData) (con unit ()) ]
                              ]
                            ]
                          ]
                        )
                      )
                    )
                  )
                ]
                (lam
                  thunk
                  Unit
                  [
                    [ (builtin constrData) (con integer 0) ]
                    [ (builtin mkNilData) (con unit ()) ]
                  ]
                )
              ]
              Unit
            ]
          )
        )
        (datatypebind
          (datatype
            (tyvardecl Credential (type))

            Credential_match
            (vardecl PubKeyCredential (fun (con bytestring) Credential))
            (vardecl ScriptCredential (fun (con bytestring) Credential))
          )
        )
        (datatypebind
          (datatype
            (tyvardecl StakingCredential (type))

            StakingCredential_match
            (vardecl StakingHash (fun Credential StakingCredential))
            (vardecl
              StakingPtr
              (fun (con integer) (fun (con integer) (fun (con integer) StakingCredential)))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl DCert (type))

            DCert_match
            (vardecl DCertDelegDeRegKey (fun StakingCredential DCert))
            (vardecl
              DCertDelegDelegate
              (fun StakingCredential (fun (con bytestring) DCert))
            )
            (vardecl DCertDelegRegKey (fun StakingCredential DCert))
            (vardecl DCertGenesis DCert)
            (vardecl DCertMir DCert)
            (vardecl
              DCertPoolRegister
              (fun (con bytestring) (fun (con bytestring) DCert))
            )
            (vardecl
              DCertPoolRetire (fun (con bytestring) (fun (con integer) DCert))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl TxOutRef (type))

            TxOutRef_match
            (vardecl
              TxOutRef (fun (con bytestring) (fun (con integer) TxOutRef))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl ScriptPurpose (type))

            ScriptPurpose_match
            (vardecl Certifying (fun DCert ScriptPurpose))
            (vardecl Minting (fun (con bytestring) ScriptPurpose))
            (vardecl Rewarding (fun StakingCredential ScriptPurpose))
            (vardecl Spending (fun TxOutRef ScriptPurpose))
          )
        )
        (datatypebind
          (datatype
            (tyvardecl Extended (fun (type) (type)))
            (tyvardecl a (type))
            Extended_match
            (vardecl Finite (fun a [Extended a]))
            (vardecl NegInf [Extended a])
            (vardecl PosInf [Extended a])
          )
        )
        (datatypebind
          (datatype
            (tyvardecl LowerBound (fun (type) (type)))
            (tyvardecl a (type))
            LowerBound_match
            (vardecl LowerBound (fun [Extended a] (fun Bool [LowerBound a])))
          )
        )
        (datatypebind
          (datatype
            (tyvardecl UpperBound (fun (type) (type)))
            (tyvardecl a (type))
            UpperBound_match
            (vardecl UpperBound (fun [Extended a] (fun Bool [UpperBound a])))
          )
        )
        (datatypebind
          (datatype
            (tyvardecl Interval (fun (type) (type)))
            (tyvardecl a (type))
            Interval_match
            (vardecl
              Interval (fun [LowerBound a] (fun [UpperBound a] [Interval a]))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl Maybe (fun (type) (type)))
            (tyvardecl a (type))
            Maybe_match
            (vardecl Just (fun a [Maybe a])) (vardecl Nothing [Maybe a])
          )
        )
        (datatypebind
          (datatype
            (tyvardecl Address (type))

            Address_match
            (vardecl
              Address (fun Credential (fun [Maybe StakingCredential] Address))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl TxOut (type))

            TxOut_match
            (vardecl
              TxOut
              (fun Address (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun [Maybe (con bytestring)] TxOut)))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl TxInInfo (type))

            TxInInfo_match
            (vardecl TxInInfo (fun TxOutRef (fun TxOut TxInInfo)))
          )
        )
        (datatypebind
          (datatype
            (tyvardecl TxInfo (type))

            TxInfo_match
            (vardecl
              TxInfo
              (fun [List TxInInfo] (fun [List TxOut] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun [List DCert] (fun [List [[Tuple2 StakingCredential] (con integer)]] (fun [Interval (con integer)] (fun [List (con bytestring)] (fun [List [[Tuple2 (con bytestring)] (con data)]] (fun (con bytestring) TxInfo))))))))))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl ScriptContext (type))

            ScriptContext_match
            (vardecl
              ScriptContext (fun TxInfo (fun ScriptPurpose ScriptContext))
            )
          )
        )
        (termbind
          (strict)
          (vardecl
            mkStateMachine
            (all s (type) (all i (type) (fun s (fun i (fun ScriptContext Bool)))))
          )
          (abs
            s
            (type)
            (abs i (type) (lam ds s (lam ds i (lam ds ScriptContext True))))
          )
        )
        (datatypebind
          (datatype
            (tyvardecl ThreadToken (type))

            ThreadToken_match
            (vardecl
              ThreadToken (fun TxOutRef (fun (con bytestring) ThreadToken))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl State (fun (type) (type)))
            (tyvardecl s (type))
            State_match
            (vardecl
              State
              (fun s (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [State s]))
            )
          )
        )
        (datatypebind (datatype (tyvardecl Void (type))  Void_match ))
        (datatypebind
          (datatype
            (tyvardecl InputConstraint (fun (type) (type)))
            (tyvardecl a (type))
            InputConstraint_match
            (vardecl InputConstraint (fun a (fun TxOutRef [InputConstraint a])))
          )
        )
        (datatypebind
          (datatype
            (tyvardecl OutputConstraint (fun (type) (type)))
            (tyvardecl a (type))
            OutputConstraint_match
            (vardecl
              OutputConstraint
              (fun a (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [OutputConstraint a]))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl TxConstraint (type))

            TxConstraint_match
            (vardecl MustBeSignedBy (fun (con bytestring) TxConstraint))
            (vardecl
              MustHashDatum (fun (con bytestring) (fun (con data) TxConstraint))
            )
            (vardecl MustIncludeDatum (fun (con data) TxConstraint))
            (vardecl
              MustMintValue
              (fun (con bytestring) (fun (con data) (fun (con bytestring) (fun (con integer) TxConstraint))))
            )
            (vardecl
              MustPayToOtherScript
              (fun (con bytestring) (fun (con data) (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] TxConstraint)))
            )
            (vardecl
              MustPayToPubKey
              (fun (con bytestring) (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] TxConstraint))
            )
            (vardecl
              MustProduceAtLeast
              (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] TxConstraint)
            )
            (vardecl
              MustSpendAtLeast
              (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] TxConstraint)
            )
            (vardecl MustSpendPubKeyOutput (fun TxOutRef TxConstraint))
            (vardecl
              MustSpendScriptOutput (fun TxOutRef (fun (con data) TxConstraint))
            )
            (vardecl MustValidateIn (fun [Interval (con integer)] TxConstraint))
          )
        )
        (datatypebind
          (datatype
            (tyvardecl TxConstraints (fun (type) (fun (type) (type))))
            (tyvardecl i (type)) (tyvardecl o (type))
            TxConstraints_match
            (vardecl
              TxConstraints
              (fun [List TxConstraint] (fun [List [InputConstraint i]] (fun [List [OutputConstraint o]] [[TxConstraints i] o])))
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl StateMachine (fun (type) (fun (type) (type))))
            (tyvardecl s (type)) (tyvardecl i (type))
            StateMachine_match
            (vardecl
              StateMachine
              (fun (fun [State s] (fun i [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State s]]])) (fun (fun s Bool) (fun (fun s (fun i (fun ScriptContext Bool))) (fun [Maybe ThreadToken] [[StateMachine s] i]))))
            )
          )
        )
        (termbind
          (strict)
          (vardecl
            fAdditiveGroupValue_cscale
            (fun (con integer) (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]))
          )
          (lam
            i
            (con integer)
            (lam
              ds
              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
              (let
                (rec)
                (termbind
                  (strict)
                  (vardecl
                    go
                    (fun [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]] [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]])
                  )
                  (lam
                    ds
                    [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                    [
                      [
                        [
                          {
                            [
                              {
                                Nil_match
                                [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                              }
                              ds
                            ]
                            (fun Unit [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]])
                          }
                          (lam
                            thunk
                            Unit
                            {
                              Nil
                              [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                            }
                          )
                        ]
                        (lam
                          ds
                          [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                          (lam
                            xs
                            [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                            (lam
                              thunk
                              Unit
                              [
                                {
                                  [
                                    {
                                      { Tuple2_match (con bytestring) }
                                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                    }
                                    ds
                                  ]
                                  [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                }
                                (lam
                                  c
                                  (con bytestring)
                                  (lam
                                    i
                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                    (let
                                      (rec)
                                      (termbind
                                        (strict)
                                        (vardecl
                                          go
                                          (fun [List [[Tuple2 (con bytestring)] (con integer)]] [List [[Tuple2 (con bytestring)] (con integer)]])
                                        )
                                        (lam
                                          ds
                                          [List [[Tuple2 (con bytestring)] (con integer)]]
                                          [
                                            [
                                              [
                                                {
                                                  [
                                                    {
                                                      Nil_match
                                                      [[Tuple2 (con bytestring)] (con integer)]
                                                    }
                                                    ds
                                                  ]
                                                  (fun Unit [List [[Tuple2 (con bytestring)] (con integer)]])
                                                }
                                                (lam
                                                  thunk
                                                  Unit
                                                  {
                                                    Nil
                                                    [[Tuple2 (con bytestring)] (con integer)]
                                                  }
                                                )
                                              ]
                                              (lam
                                                ds
                                                [[Tuple2 (con bytestring)] (con integer)]
                                                (lam
                                                  xs
                                                  [List [[Tuple2 (con bytestring)] (con integer)]]
                                                  (lam
                                                    thunk
                                                    Unit
                                                    [
                                                      {
                                                        [
                                                          {
                                                            {
                                                              Tuple2_match
                                                              (con bytestring)
                                                            }
                                                            (con integer)
                                                          }
                                                          ds
                                                        ]
                                                        [List [[Tuple2 (con bytestring)] (con integer)]]
                                                      }
                                                      (lam
                                                        c
                                                        (con bytestring)
                                                        (lam
                                                          i
                                                          (con integer)
                                                          [
                                                            [
                                                              {
                                                                Cons
                                                                [[Tuple2 (con bytestring)] (con integer)]
                                                              }
                                                              [
                                                                [
                                                                  {
                                                                    {
                                                                      Tuple2
                                                                      (con bytestring)
                                                                    }
                                                                    (con integer)
                                                                  }
                                                                  c
                                                                ]
                                                                [
                                                                  [
                                                                    (builtin
                                                                      multiplyInteger
                                                                    )
                                                                    i
                                                                  ]
                                                                  i
                                                                ]
                                                              ]
                                                            ]
                                                            [ go xs ]
                                                          ]
                                                        )
                                                      )
                                                    ]
                                                  )
                                                )
                                              )
                                            ]
                                            Unit
                                          ]
                                        )
                                      )
                                      [
                                        [
                                          {
                                            Cons
                                            [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                          }
                                          [
                                            [
                                              {
                                                { Tuple2 (con bytestring) }
                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                              }
                                              c
                                            ]
                                            [ go i ]
                                          ]
                                        ]
                                        [ go xs ]
                                      ]
                                    )
                                  )
                                )
                              ]
                            )
                          )
                        )
                      ]
                      Unit
                    ]
                  )
                )
                [ go ds ]
              )
            )
          )
        )
        (termbind
          (strict)
          (vardecl
            addInteger (fun (con integer) (fun (con integer) (con integer)))
          )
          (lam
            x
            (con integer)
            (lam y (con integer) [ [ (builtin addInteger) x ] y ])
          )
        )
        (termbind
          (strict)
          (vardecl
            equalsByteString (fun (con bytestring) (fun (con bytestring) Bool))
          )
          (lam
            x
            (con bytestring)
            (lam
              y
              (con bytestring)
              [
                [
                  [
                    { (builtin ifThenElse) Bool }
                    [ [ (builtin equalsByteString) x ] y ]
                  ]
                  True
                ]
                False
              ]
            )
          )
        )
        (datatypebind
          (datatype
            (tyvardecl AdditiveMonoid (fun (type) (type)))
            (tyvardecl a (type))
            AdditiveMonoid_match
            (vardecl
              CConsAdditiveMonoid
              (fun [(lam a (type) (fun a (fun a a))) a] (fun a [AdditiveMonoid a]))
            )
          )
        )
        (termbind
          (strict)
          (vardecl bad_name (fun Bool (fun Bool Bool)))
          (lam
            ds
            Bool
            (lam
              ds
              Bool
              [
                [
                  [
                    { [ Bool_match ds ] (fun Unit Bool) } (lam thunk Unit True)
                  ]
                  (lam thunk Unit ds)
                ]
                Unit
              ]
            )
          )
        )
        (termbind
          (nonstrict)
          (vardecl fAdditiveMonoidBool [AdditiveMonoid Bool])
          [ [ { CConsAdditiveMonoid Bool } bad_name ] False ]
        )
        (datatypebind
          (datatype
            (tyvardecl Monoid (fun (type) (type)))
            (tyvardecl a (type))
            Monoid_match
            (vardecl
              CConsMonoid
              (fun [(lam a (type) (fun a (fun a a))) a] (fun a [Monoid a]))
            )
          )
        )
        (termbind
          (strict)
          (vardecl
            p1Monoid
            (all a (type) (fun [Monoid a] [(lam a (type) (fun a (fun a a))) a]))
          )
          (abs
            a
            (type)
            (lam
              v
              [Monoid a]
              [
                {
                  [ { Monoid_match a } v ] [(lam a (type) (fun a (fun a a))) a]
                }
                (lam v [(lam a (type) (fun a (fun a a))) a] (lam v a v))
              ]
            )
          )
        )
        (termbind
          (strict)
          (vardecl mempty (all a (type) (fun [Monoid a] a)))
          (abs
            a
            (type)
            (lam
              v
              [Monoid a]
              [
                { [ { Monoid_match a } v ] a }
                (lam v [(lam a (type) (fun a (fun a a))) a] (lam v a v))
              ]
            )
          )
        )
        (let
          (rec)
          (termbind
            (nonstrict)
            (vardecl
              fFoldableNil_cfoldMap
              (all m (type) (all a (type) (fun [Monoid m] (fun (fun a m) (fun [List a] m)))))
            )
            (abs
              m
              (type)
              (abs
                a
                (type)
                (lam
                  dMonoid
                  [Monoid m]
                  (let
                    (nonrec)
                    (termbind
                      (nonstrict)
                      (vardecl dSemigroup [(lam a (type) (fun a (fun a a))) m])
                      [ { p1Monoid m } dMonoid ]
                    )
                    (lam
                      ds
                      (fun a m)
                      (lam
                        ds
                        [List a]
                        [
                          [
                            [
                              { [ { Nil_match a } ds ] (fun Unit m) }
                              (lam thunk Unit [ { mempty m } dMonoid ])
                            ]
                            (lam
                              x
                              a
                              (lam
                                xs
                                [List a]
                                (lam
                                  thunk
                                  Unit
                                  [
                                    [ dSemigroup [ ds x ] ]
                                    [
                                      [
                                        [
                                          { { fFoldableNil_cfoldMap m } a }
                                          dMonoid
                                        ]
                                        ds
                                      ]
                                      xs
                                    ]
                                  ]
                                )
                              )
                            )
                          ]
                          Unit
                        ]
                      )
                    )
                  )
                )
              )
            )
          )
          (let
            (rec)
            (termbind
              (nonstrict)
              (vardecl
                fFunctorNil_cfmap
                (all a (type) (all b (type) (fun (fun a b) (fun [List a] [List b]))))
              )
              (abs
                a
                (type)
                (abs
                  b
                  (type)
                  (lam
                    f
                    (fun a b)
                    (lam
                      l
                      [List a]
                      [
                        [
                          [
                            { [ { Nil_match a } l ] (fun Unit [List b]) }
                            (lam thunk Unit { Nil b })
                          ]
                          (lam
                            x
                            a
                            (lam
                              xs
                              [List a]
                              (lam
                                thunk
                                Unit
                                [
                                  [ { Cons b } [ f x ] ]
                                  [ [ { { fFunctorNil_cfmap a } b } f ] xs ]
                                ]
                              )
                            )
                          )
                        ]
                        Unit
                      ]
                    )
                  )
                )
              )
            )
            (let
              (nonrec)
              (termbind
                (strict)
                (vardecl
                  p1AdditiveMonoid
                  (all a (type) (fun [AdditiveMonoid a] [(lam a (type) (fun a (fun a a))) a]))
                )
                (abs
                  a
                  (type)
                  (lam
                    v
                    [AdditiveMonoid a]
                    [
                      {
                        [ { AdditiveMonoid_match a } v ]
                        [(lam a (type) (fun a (fun a a))) a]
                      }
                      (lam v [(lam a (type) (fun a (fun a a))) a] (lam v a v))
                    ]
                  )
                )
              )
              (termbind
                (strict)
                (vardecl zero (all a (type) (fun [AdditiveMonoid a] a)))
                (abs
                  a
                  (type)
                  (lam
                    v
                    [AdditiveMonoid a]
                    [
                      { [ { AdditiveMonoid_match a } v ] a }
                      (lam v [(lam a (type) (fun a (fun a a))) a] (lam v a v))
                    ]
                  )
                )
              )
              (termbind
                (strict)
                (vardecl
                  fMonoidSum
                  (all a (type) (fun [AdditiveMonoid a] [Monoid [(lam a (type) a) a]]))
                )
                (abs
                  a
                  (type)
                  (lam
                    v
                    [AdditiveMonoid a]
                    [
                      [
                        { CConsMonoid [(lam a (type) a) a] }
                        (lam
                          eta
                          [(lam a (type) a) a]
                          (lam
                            eta
                            [(lam a (type) a) a]
                            [ [ [ { p1AdditiveMonoid a } v ] eta ] eta ]
                          )
                        )
                      ]
                      [ { zero a } v ]
                    ]
                  )
                )
              )
              (let
                (rec)
                (termbind
                  (nonstrict)
                  (vardecl
                    foldr
                    (all a (type) (all b (type) (fun (fun a (fun b b)) (fun b (fun [List a] b)))))
                  )
                  (abs
                    a
                    (type)
                    (abs
                      b
                      (type)
                      (lam
                        f
                        (fun a (fun b b))
                        (lam
                          acc
                          b
                          (lam
                            l
                            [List a]
                            [
                              [
                                [
                                  { [ { Nil_match a } l ] (fun Unit b) }
                                  (lam thunk Unit acc)
                                ]
                                (lam
                                  x
                                  a
                                  (lam
                                    xs
                                    [List a]
                                    (lam
                                      thunk
                                      Unit
                                      [
                                        [ f x ]
                                        [ [ [ { { foldr a } b } f ] acc ] xs ]
                                      ]
                                    )
                                  )
                                )
                              ]
                              Unit
                            ]
                          )
                        )
                      )
                    )
                  )
                )
                (let
                  (nonrec)
                  (termbind
                    (strict)
                    (vardecl
                      union
                      (all k (type) (all v (type) (all r (type) (fun [(lam a (type) (fun a (fun a Bool))) k] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) k] v] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) k] r] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) k] [[These v] r]]))))))
                    )
                    (abs
                      k
                      (type)
                      (abs
                        v
                        (type)
                        (abs
                          r
                          (type)
                          (lam
                            dEq
                            [(lam a (type) (fun a (fun a Bool))) k]
                            (lam
                              ds
                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) k] v]
                              (lam
                                ds
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) k] r]
                                [
                                  [
                                    [
                                      {
                                        { foldr [[Tuple2 k] [[These v] r]] }
                                        [List [[Tuple2 k] [[These v] r]]]
                                      }
                                      { Cons [[Tuple2 k] [[These v] r]] }
                                    ]
                                    [
                                      [
                                        {
                                          { fFunctorNil_cfmap [[Tuple2 k] r] }
                                          [[Tuple2 k] [[These v] r]]
                                        }
                                        (lam
                                          ds
                                          [[Tuple2 k] r]
                                          [
                                            {
                                              [ { { Tuple2_match k } r } ds ]
                                              [[Tuple2 k] [[These v] r]]
                                            }
                                            (lam
                                              c
                                              k
                                              (lam
                                                b
                                                r
                                                [
                                                  [
                                                    {
                                                      { Tuple2 k } [[These v] r]
                                                    }
                                                    c
                                                  ]
                                                  [ { { That v } r } b ]
                                                ]
                                              )
                                            )
                                          ]
                                        )
                                      ]
                                      [
                                        [
                                          [
                                            {
                                              { foldr [[Tuple2 k] r] }
                                              [List [[Tuple2 k] r]]
                                            }
                                            (lam
                                              e
                                              [[Tuple2 k] r]
                                              (lam
                                                xs
                                                [List [[Tuple2 k] r]]
                                                [
                                                  {
                                                    [
                                                      { { Tuple2_match k } r } e
                                                    ]
                                                    [List [[Tuple2 k] r]]
                                                  }
                                                  (lam
                                                    c
                                                    k
                                                    (lam
                                                      ds
                                                      r
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                Bool_match
                                                                [
                                                                  [
                                                                    [
                                                                      {
                                                                        {
                                                                          fFoldableNil_cfoldMap
                                                                          [(lam a (type) a) Bool]
                                                                        }
                                                                        [[Tuple2 k] v]
                                                                      }
                                                                      [
                                                                        {
                                                                          fMonoidSum
                                                                          Bool
                                                                        }
                                                                        fAdditiveMonoidBool
                                                                      ]
                                                                    ]
                                                                    (lam
                                                                      ds
                                                                      [[Tuple2 k] v]
                                                                      [
                                                                        {
                                                                          [
                                                                            {
                                                                              {
                                                                                Tuple2_match
                                                                                k
                                                                              }
                                                                              v
                                                                            }
                                                                            ds
                                                                          ]
                                                                          Bool
                                                                        }
                                                                        (lam
                                                                          c
                                                                          k
                                                                          (lam
                                                                            ds
                                                                            v
                                                                            [
                                                                              [
                                                                                dEq
                                                                                c
                                                                              ]
                                                                              c
                                                                            ]
                                                                          )
                                                                        )
                                                                      ]
                                                                    )
                                                                  ]
                                                                  ds
                                                                ]
                                                              ]
                                                              (fun Unit [List [[Tuple2 k] r]])
                                                            }
                                                            (lam thunk Unit xs)
                                                          ]
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              [
                                                                {
                                                                  Cons
                                                                  [[Tuple2 k] r]
                                                                }
                                                                e
                                                              ]
                                                              xs
                                                            ]
                                                          )
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  )
                                                ]
                                              )
                                            )
                                          ]
                                          { Nil [[Tuple2 k] r] }
                                        ]
                                        ds
                                      ]
                                    ]
                                  ]
                                  [
                                    [
                                      {
                                        { fFunctorNil_cfmap [[Tuple2 k] v] }
                                        [[Tuple2 k] [[These v] r]]
                                      }
                                      (lam
                                        ds
                                        [[Tuple2 k] v]
                                        [
                                          {
                                            [ { { Tuple2_match k } v } ds ]
                                            [[Tuple2 k] [[These v] r]]
                                          }
                                          (lam
                                            c
                                            k
                                            (lam
                                              i
                                              v
                                              (let
                                                (rec)
                                                (termbind
                                                  (strict)
                                                  (vardecl
                                                    go
                                                    (fun [List [[Tuple2 k] r]] [[These v] r])
                                                  )
                                                  (lam
                                                    ds
                                                    [List [[Tuple2 k] r]]
                                                    [
                                                      [
                                                        [
                                                          {
                                                            [
                                                              {
                                                                Nil_match
                                                                [[Tuple2 k] r]
                                                              }
                                                              ds
                                                            ]
                                                            (fun Unit [[These v] r])
                                                          }
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              { { This v } r } i
                                                            ]
                                                          )
                                                        ]
                                                        (lam
                                                          ds
                                                          [[Tuple2 k] r]
                                                          (lam
                                                            xs
                                                            [List [[Tuple2 k] r]]
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                {
                                                                  [
                                                                    {
                                                                      {
                                                                        Tuple2_match
                                                                        k
                                                                      }
                                                                      r
                                                                    }
                                                                    ds
                                                                  ]
                                                                  [[These v] r]
                                                                }
                                                                (lam
                                                                  c
                                                                  k
                                                                  (lam
                                                                    i
                                                                    r
                                                                    [
                                                                      [
                                                                        [
                                                                          {
                                                                            [
                                                                              Bool_match
                                                                              [
                                                                                [
                                                                                  dEq
                                                                                  c
                                                                                ]
                                                                                c
                                                                              ]
                                                                            ]
                                                                            (fun Unit [[These v] r])
                                                                          }
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            [
                                                                              [
                                                                                {
                                                                                  {
                                                                                    These
                                                                                    v
                                                                                  }
                                                                                  r
                                                                                }
                                                                                i
                                                                              ]
                                                                              i
                                                                            ]
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          [
                                                                            go
                                                                            xs
                                                                          ]
                                                                        )
                                                                      ]
                                                                      Unit
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                            )
                                                          )
                                                        )
                                                      ]
                                                      Unit
                                                    ]
                                                  )
                                                )
                                                [
                                                  [
                                                    {
                                                      { Tuple2 k } [[These v] r]
                                                    }
                                                    c
                                                  ]
                                                  [ go ds ]
                                                ]
                                              )
                                            )
                                          )
                                        ]
                                      )
                                    ]
                                    ds
                                  ]
                                ]
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      unionVal
                      (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]))
                    )
                    (lam
                      ds
                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                      (lam
                        ds
                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                        (let
                          (rec)
                          (termbind
                            (strict)
                            (vardecl
                              go
                              (fun [List [[Tuple2 (con bytestring)] [[These [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]] [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]])
                            )
                            (lam
                              ds
                              [List [[Tuple2 (con bytestring)] [[These [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]]
                              [
                                [
                                  [
                                    {
                                      [
                                        {
                                          Nil_match
                                          [[Tuple2 (con bytestring)] [[These [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                        }
                                        ds
                                      ]
                                      (fun Unit [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]])
                                    }
                                    (lam
                                      thunk
                                      Unit
                                      {
                                        Nil
                                        [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]
                                      }
                                    )
                                  ]
                                  (lam
                                    ds
                                    [[Tuple2 (con bytestring)] [[These [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                    (lam
                                      xs
                                      [List [[Tuple2 (con bytestring)] [[These [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]]
                                      (lam
                                        thunk
                                        Unit
                                        [
                                          {
                                            [
                                              {
                                                {
                                                  Tuple2_match (con bytestring)
                                                }
                                                [[These [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                              }
                                              ds
                                            ]
                                            [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]]
                                          }
                                          (lam
                                            c
                                            (con bytestring)
                                            (lam
                                              i
                                              [[These [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                              [
                                                [
                                                  {
                                                    Cons
                                                    [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]
                                                  }
                                                  [
                                                    [
                                                      {
                                                        {
                                                          Tuple2
                                                          (con bytestring)
                                                        }
                                                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]
                                                      }
                                                      c
                                                    ]
                                                    [
                                                      [
                                                        [
                                                          {
                                                            [
                                                              {
                                                                {
                                                                  These_match
                                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                                                }
                                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                                              }
                                                              i
                                                            ]
                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]
                                                          }
                                                          (lam
                                                            b
                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                                            (let
                                                              (rec)
                                                              (termbind
                                                                (strict)
                                                                (vardecl
                                                                  go
                                                                  (fun [List [[Tuple2 (con bytestring)] (con integer)]] [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]])
                                                                )
                                                                (lam
                                                                  ds
                                                                  [List [[Tuple2 (con bytestring)] (con integer)]]
                                                                  [
                                                                    [
                                                                      [
                                                                        {
                                                                          [
                                                                            {
                                                                              Nil_match
                                                                              [[Tuple2 (con bytestring)] (con integer)]
                                                                            }
                                                                            ds
                                                                          ]
                                                                          (fun Unit [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]])
                                                                        }
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          {
                                                                            Nil
                                                                            [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]
                                                                          }
                                                                        )
                                                                      ]
                                                                      (lam
                                                                        ds
                                                                        [[Tuple2 (con bytestring)] (con integer)]
                                                                        (lam
                                                                          xs
                                                                          [List [[Tuple2 (con bytestring)] (con integer)]]
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            [
                                                                              {
                                                                                [
                                                                                  {
                                                                                    {
                                                                                      Tuple2_match
                                                                                      (con bytestring)
                                                                                    }
                                                                                    (con integer)
                                                                                  }
                                                                                  ds
                                                                                ]
                                                                                [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]]
                                                                              }
                                                                              (lam
                                                                                c
                                                                                (con bytestring)
                                                                                (lam
                                                                                  i
                                                                                  (con integer)
                                                                                  [
                                                                                    [
                                                                                      {
                                                                                        Cons
                                                                                        [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]
                                                                                      }
                                                                                      [
                                                                                        [
                                                                                          {
                                                                                            {
                                                                                              Tuple2
                                                                                              (con bytestring)
                                                                                            }
                                                                                            [[These (con integer)] (con integer)]
                                                                                          }
                                                                                          c
                                                                                        ]
                                                                                        [
                                                                                          {
                                                                                            {
                                                                                              That
                                                                                              (con integer)
                                                                                            }
                                                                                            (con integer)
                                                                                          }
                                                                                          i
                                                                                        ]
                                                                                      ]
                                                                                    ]
                                                                                    [
                                                                                      go
                                                                                      xs
                                                                                    ]
                                                                                  ]
                                                                                )
                                                                              )
                                                                            ]
                                                                          )
                                                                        )
                                                                      )
                                                                    ]
                                                                    Unit
                                                                  ]
                                                                )
                                                              )
                                                              [ go b ]
                                                            )
                                                          )
                                                        ]
                                                        (lam
                                                          a
                                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                                          (lam
                                                            b
                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                                            [
                                                              [
                                                                [
                                                                  {
                                                                    {
                                                                      {
                                                                        union
                                                                        (con bytestring)
                                                                      }
                                                                      (con integer)
                                                                    }
                                                                    (con integer)
                                                                  }
                                                                  equalsByteString
                                                                ]
                                                                a
                                                              ]
                                                              b
                                                            ]
                                                          )
                                                        )
                                                      ]
                                                      (lam
                                                        a
                                                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                                        (let
                                                          (rec)
                                                          (termbind
                                                            (strict)
                                                            (vardecl
                                                              go
                                                              (fun [List [[Tuple2 (con bytestring)] (con integer)]] [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]])
                                                            )
                                                            (lam
                                                              ds
                                                              [List [[Tuple2 (con bytestring)] (con integer)]]
                                                              [
                                                                [
                                                                  [
                                                                    {
                                                                      [
                                                                        {
                                                                          Nil_match
                                                                          [[Tuple2 (con bytestring)] (con integer)]
                                                                        }
                                                                        ds
                                                                      ]
                                                                      (fun Unit [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]])
                                                                    }
                                                                    (lam
                                                                      thunk
                                                                      Unit
                                                                      {
                                                                        Nil
                                                                        [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]
                                                                      }
                                                                    )
                                                                  ]
                                                                  (lam
                                                                    ds
                                                                    [[Tuple2 (con bytestring)] (con integer)]
                                                                    (lam
                                                                      xs
                                                                      [List [[Tuple2 (con bytestring)] (con integer)]]
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        [
                                                                          {
                                                                            [
                                                                              {
                                                                                {
                                                                                  Tuple2_match
                                                                                  (con bytestring)
                                                                                }
                                                                                (con integer)
                                                                              }
                                                                              ds
                                                                            ]
                                                                            [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]]
                                                                          }
                                                                          (lam
                                                                            c
                                                                            (con bytestring)
                                                                            (lam
                                                                              i
                                                                              (con integer)
                                                                              [
                                                                                [
                                                                                  {
                                                                                    Cons
                                                                                    [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]
                                                                                  }
                                                                                  [
                                                                                    [
                                                                                      {
                                                                                        {
                                                                                          Tuple2
                                                                                          (con bytestring)
                                                                                        }
                                                                                        [[These (con integer)] (con integer)]
                                                                                      }
                                                                                      c
                                                                                    ]
                                                                                    [
                                                                                      {
                                                                                        {
                                                                                          This
                                                                                          (con integer)
                                                                                        }
                                                                                        (con integer)
                                                                                      }
                                                                                      i
                                                                                    ]
                                                                                  ]
                                                                                ]
                                                                                [
                                                                                  go
                                                                                  xs
                                                                                ]
                                                                              ]
                                                                            )
                                                                          )
                                                                        ]
                                                                      )
                                                                    )
                                                                  )
                                                                ]
                                                                Unit
                                                              ]
                                                            )
                                                          )
                                                          [ go a ]
                                                        )
                                                      )
                                                    ]
                                                  ]
                                                ]
                                                [ go xs ]
                                              ]
                                            )
                                          )
                                        ]
                                      )
                                    )
                                  )
                                ]
                                Unit
                              ]
                            )
                          )
                          [
                            go
                            [
                              [
                                [
                                  {
                                    {
                                      { union (con bytestring) }
                                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                    }
                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                  }
                                  equalsByteString
                                ]
                                ds
                              ]
                              ds
                            ]
                          ]
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      unionWith
                      (fun (fun (con integer) (fun (con integer) (con integer))) (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]])))
                    )
                    (lam
                      f
                      (fun (con integer) (fun (con integer) (con integer)))
                      (lam
                        ls
                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                        (lam
                          rs
                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                          (let
                            (rec)
                            (termbind
                              (strict)
                              (vardecl
                                go
                                (fun [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]] [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]])
                              )
                              (lam
                                ds
                                [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]]
                                [
                                  [
                                    [
                                      {
                                        [
                                          {
                                            Nil_match
                                            [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]
                                          }
                                          ds
                                        ]
                                        (fun Unit [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]])
                                      }
                                      (lam
                                        thunk
                                        Unit
                                        {
                                          Nil
                                          [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                        }
                                      )
                                    ]
                                    (lam
                                      ds
                                      [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]
                                      (lam
                                        xs
                                        [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]]
                                        (lam
                                          thunk
                                          Unit
                                          [
                                            {
                                              [
                                                {
                                                  {
                                                    Tuple2_match
                                                    (con bytestring)
                                                  }
                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]
                                                }
                                                ds
                                              ]
                                              [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                            }
                                            (lam
                                              c
                                              (con bytestring)
                                              (lam
                                                i
                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]
                                                (let
                                                  (rec)
                                                  (termbind
                                                    (strict)
                                                    (vardecl
                                                      go
                                                      (fun [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]] [List [[Tuple2 (con bytestring)] (con integer)]])
                                                    )
                                                    (lam
                                                      ds
                                                      [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]]
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                {
                                                                  Nil_match
                                                                  [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]
                                                                }
                                                                ds
                                                              ]
                                                              (fun Unit [List [[Tuple2 (con bytestring)] (con integer)]])
                                                            }
                                                            (lam
                                                              thunk
                                                              Unit
                                                              {
                                                                Nil
                                                                [[Tuple2 (con bytestring)] (con integer)]
                                                              }
                                                            )
                                                          ]
                                                          (lam
                                                            ds
                                                            [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]
                                                            (lam
                                                              xs
                                                              [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                [
                                                                  {
                                                                    [
                                                                      {
                                                                        {
                                                                          Tuple2_match
                                                                          (con bytestring)
                                                                        }
                                                                        [[These (con integer)] (con integer)]
                                                                      }
                                                                      ds
                                                                    ]
                                                                    [List [[Tuple2 (con bytestring)] (con integer)]]
                                                                  }
                                                                  (lam
                                                                    c
                                                                    (con bytestring)
                                                                    (lam
                                                                      i
                                                                      [[These (con integer)] (con integer)]
                                                                      [
                                                                        [
                                                                          {
                                                                            Cons
                                                                            [[Tuple2 (con bytestring)] (con integer)]
                                                                          }
                                                                          [
                                                                            [
                                                                              {
                                                                                {
                                                                                  Tuple2
                                                                                  (con bytestring)
                                                                                }
                                                                                (con integer)
                                                                              }
                                                                              c
                                                                            ]
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    [
                                                                                      {
                                                                                        {
                                                                                          These_match
                                                                                          (con integer)
                                                                                        }
                                                                                        (con integer)
                                                                                      }
                                                                                      i
                                                                                    ]
                                                                                    (con integer)
                                                                                  }
                                                                                  (lam
                                                                                    b
                                                                                    (con integer)
                                                                                    [
                                                                                      [
                                                                                        f
                                                                                        (con
                                                                                          integer
                                                                                            0
                                                                                        )
                                                                                      ]
                                                                                      b
                                                                                    ]
                                                                                  )
                                                                                ]
                                                                                (lam
                                                                                  a
                                                                                  (con integer)
                                                                                  (lam
                                                                                    b
                                                                                    (con integer)
                                                                                    [
                                                                                      [
                                                                                        f
                                                                                        a
                                                                                      ]
                                                                                      b
                                                                                    ]
                                                                                  )
                                                                                )
                                                                              ]
                                                                              (lam
                                                                                a
                                                                                (con integer)
                                                                                [
                                                                                  [
                                                                                    f
                                                                                    a
                                                                                  ]
                                                                                  (con
                                                                                    integer
                                                                                      0
                                                                                  )
                                                                                ]
                                                                              )
                                                                            ]
                                                                          ]
                                                                        ]
                                                                        [
                                                                          go xs
                                                                        ]
                                                                      ]
                                                                    )
                                                                  )
                                                                ]
                                                              )
                                                            )
                                                          )
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  )
                                                  [
                                                    [
                                                      {
                                                        Cons
                                                        [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                      }
                                                      [
                                                        [
                                                          {
                                                            {
                                                              Tuple2
                                                              (con bytestring)
                                                            }
                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                                          }
                                                          c
                                                        ]
                                                        [ go i ]
                                                      ]
                                                    ]
                                                    [ go xs ]
                                                  ]
                                                )
                                              )
                                            )
                                          ]
                                        )
                                      )
                                    )
                                  ]
                                  Unit
                                ]
                              )
                            )
                            [ go [ [ unionVal ls ] rs ] ]
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fAdditiveGroupValue
                      (fun [(lam a (type) a) [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]] (fun [(lam a (type) a) [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]))
                    )
                    (lam
                      ds
                      [(lam a (type) a) [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                      (lam
                        ds
                        [(lam a (type) a) [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                        [
                          [ [ unionWith addInteger ] ds ]
                          [ [ fAdditiveGroupValue_cscale (con integer -1) ] ds ]
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fMonoidTxConstraints_cmempty
                      (all i (type) (all o (type) [[TxConstraints i] o]))
                    )
                    (abs
                      i
                      (type)
                      (abs
                        o
                        (type)
                        [
                          [
                            [ { { TxConstraints i } o } { Nil TxConstraint } ]
                            { Nil [InputConstraint i] }
                          ]
                          { Nil [OutputConstraint o] }
                        ]
                      )
                    )
                  )
                  (datatypebind
                    (datatype
                      (tyvardecl Input (type))

                      Input_match
                      (vardecl AddSignature (fun (con bytestring) Input))
                      (vardecl Cancel Input)
                      (vardecl Pay Input)
                      (vardecl ProposePayment (fun Payment Input))
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      checkBinRel
                      (fun (fun (con integer) (fun (con integer) Bool)) (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] Bool)))
                    )
                    (lam
                      f
                      (fun (con integer) (fun (con integer) Bool))
                      (lam
                        l
                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                        (lam
                          r
                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                          (let
                            (rec)
                            (termbind
                              (strict)
                              (vardecl
                                go
                                (fun [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]] Bool)
                              )
                              (lam
                                xs
                                [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]]
                                [
                                  [
                                    [
                                      {
                                        [
                                          {
                                            Nil_match
                                            [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]
                                          }
                                          xs
                                        ]
                                        (fun Unit Bool)
                                      }
                                      (lam thunk Unit True)
                                    ]
                                    (lam
                                      ds
                                      [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]
                                      (lam
                                        xs
                                        [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]]]
                                        (lam
                                          thunk
                                          Unit
                                          [
                                            {
                                              [
                                                {
                                                  {
                                                    Tuple2_match
                                                    (con bytestring)
                                                  }
                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]
                                                }
                                                ds
                                              ]
                                              Bool
                                            }
                                            (lam
                                              ds
                                              (con bytestring)
                                              (lam
                                                x
                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[These (con integer)] (con integer)]]
                                                (let
                                                  (rec)
                                                  (termbind
                                                    (strict)
                                                    (vardecl
                                                      go
                                                      (fun [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]] Bool)
                                                    )
                                                    (lam
                                                      xs
                                                      [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]]
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                {
                                                                  Nil_match
                                                                  [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]
                                                                }
                                                                xs
                                                              ]
                                                              (fun Unit Bool)
                                                            }
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [ go xs ]
                                                            )
                                                          ]
                                                          (lam
                                                            ds
                                                            [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]
                                                            (lam
                                                              xs
                                                              [List [[Tuple2 (con bytestring)] [[These (con integer)] (con integer)]]]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                [
                                                                  {
                                                                    [
                                                                      {
                                                                        {
                                                                          Tuple2_match
                                                                          (con bytestring)
                                                                        }
                                                                        [[These (con integer)] (con integer)]
                                                                      }
                                                                      ds
                                                                    ]
                                                                    Bool
                                                                  }
                                                                  (lam
                                                                    ds
                                                                    (con bytestring)
                                                                    (lam
                                                                      x
                                                                      [[These (con integer)] (con integer)]
                                                                      [
                                                                        [
                                                                          [
                                                                            {
                                                                              [
                                                                                {
                                                                                  {
                                                                                    These_match
                                                                                    (con integer)
                                                                                  }
                                                                                  (con integer)
                                                                                }
                                                                                x
                                                                              ]
                                                                              Bool
                                                                            }
                                                                            (lam
                                                                              b
                                                                              (con integer)
                                                                              [
                                                                                [
                                                                                  [
                                                                                    {
                                                                                      [
                                                                                        Bool_match
                                                                                        [
                                                                                          [
                                                                                            f
                                                                                            (con
                                                                                              integer
                                                                                                0
                                                                                            )
                                                                                          ]
                                                                                          b
                                                                                        ]
                                                                                      ]
                                                                                      (fun Unit Bool)
                                                                                    }
                                                                                    (lam
                                                                                      thunk
                                                                                      Unit
                                                                                      [
                                                                                        go
                                                                                        xs
                                                                                      ]
                                                                                    )
                                                                                  ]
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    False
                                                                                  )
                                                                                ]
                                                                                Unit
                                                                              ]
                                                                            )
                                                                          ]
                                                                          (lam
                                                                            a
                                                                            (con integer)
                                                                            (lam
                                                                              b
                                                                              (con integer)
                                                                              [
                                                                                [
                                                                                  [
                                                                                    {
                                                                                      [
                                                                                        Bool_match
                                                                                        [
                                                                                          [
                                                                                            f
                                                                                            a
                                                                                          ]
                                                                                          b
                                                                                        ]
                                                                                      ]
                                                                                      (fun Unit Bool)
                                                                                    }
                                                                                    (lam
                                                                                      thunk
                                                                                      Unit
                                                                                      [
                                                                                        go
                                                                                        xs
                                                                                      ]
                                                                                    )
                                                                                  ]
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    False
                                                                                  )
                                                                                ]
                                                                                Unit
                                                                              ]
                                                                            )
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          a
                                                                          (con integer)
                                                                          [
                                                                            [
                                                                              [
                                                                                {
                                                                                  [
                                                                                    Bool_match
                                                                                    [
                                                                                      [
                                                                                        f
                                                                                        a
                                                                                      ]
                                                                                      (con
                                                                                        integer
                                                                                          0
                                                                                      )
                                                                                    ]
                                                                                  ]
                                                                                  (fun Unit Bool)
                                                                                }
                                                                                (lam
                                                                                  thunk
                                                                                  Unit
                                                                                  [
                                                                                    go
                                                                                    xs
                                                                                  ]
                                                                                )
                                                                              ]
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                False
                                                                              )
                                                                            ]
                                                                            Unit
                                                                          ]
                                                                        )
                                                                      ]
                                                                    )
                                                                  )
                                                                ]
                                                              )
                                                            )
                                                          )
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  )
                                                  [ go x ]
                                                )
                                              )
                                            )
                                          ]
                                        )
                                      )
                                    )
                                  ]
                                  Unit
                                ]
                              )
                            )
                            [ go [ [ unionVal l ] r ] ]
                          )
                        )
                      )
                    )
                  )
                  (datatypebind
                    (datatype
                      (tyvardecl Params (type))

                      Params_match
                      (vardecl
                        Params
                        (fun [List (con bytestring)] (fun (con integer) Params))
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      isSignatory (fun (con bytestring) (fun Params Bool))
                    )
                    (lam
                      pkh
                      (con bytestring)
                      (lam
                        ds
                        Params
                        [
                          { [ Params_match ds ] Bool }
                          (lam
                            sigs
                            [List (con bytestring)]
                            (lam
                              ds
                              (con integer)
                              [
                                [
                                  [
                                    {
                                      {
                                        fFoldableNil_cfoldMap
                                        [(lam a (type) a) Bool]
                                      }
                                      (con bytestring)
                                    }
                                    [ { fMonoidSum Bool } fAdditiveMonoidBool ]
                                  ]
                                  (lam
                                    pkh
                                    (con bytestring)
                                    [ [ equalsByteString pkh ] pkh ]
                                  )
                                ]
                                sigs
                              ]
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      lessThanEqInteger
                      (fun (con integer) (fun (con integer) Bool))
                    )
                    (lam
                      x
                      (con integer)
                      (lam
                        y
                        (con integer)
                        [
                          [
                            [
                              { (builtin ifThenElse) Bool }
                              [ [ (builtin lessThanEqualsInteger) x ] y ]
                            ]
                            True
                          ]
                          False
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      build
                      (all a (type) (fun (all b (type) (fun (fun a (fun b b)) (fun b b))) [List a]))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        g
                        (all b (type) (fun (fun a (fun b b)) (fun b b)))
                        [ [ { g [List a] } { Cons a } ] { Nil a } ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      mustBeSignedBy
                      (all i (type) (all o (type) (fun (con bytestring) [[TxConstraints i] o])))
                    )
                    (abs
                      i
                      (type)
                      (abs
                        o
                        (type)
                        (lam
                          x
                          (con bytestring)
                          [
                            [
                              [
                                { { TxConstraints i } o }
                                [
                                  { build TxConstraint }
                                  (abs
                                    a
                                    (type)
                                    (lam
                                      c
                                      (fun TxConstraint (fun a a))
                                      (lam n a [ [ c [ MustBeSignedBy x ] ] n ])
                                    )
                                  )
                                ]
                              ]
                              { Nil [InputConstraint i] }
                            ]
                            { Nil [OutputConstraint o] }
                          ]
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fMonoidDual
                      (all a (type) (fun [Monoid a] [Monoid [(lam a (type) a) a]]))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        v
                        [Monoid a]
                        [
                          [
                            { CConsMonoid [(lam a (type) a) a] }
                            (lam
                              eta
                              [(lam a (type) a) a]
                              (lam
                                eta
                                [(lam a (type) a) a]
                                [ [ [ { p1Monoid a } v ] eta ] eta ]
                              )
                            )
                          ]
                          [ { mempty a } v ]
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      bad_name
                      (all b (type) (all c (type) (all a (type) (fun (fun b c) (fun (fun a b) (fun a c))))))
                    )
                    (abs
                      b
                      (type)
                      (abs
                        c
                        (type)
                        (abs
                          a
                          (type)
                          (lam
                            f
                            (fun b c)
                            (lam g (fun a b) (lam x a [ f [ g x ] ]))
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fSemigroupEndo_c
                      (all a (type) (fun [(lam a (type) (fun a a)) a] (fun [(lam a (type) (fun a a)) a] [(lam a (type) (fun a a)) a])))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        ds
                        [(lam a (type) (fun a a)) a]
                        (lam
                          ds
                          [(lam a (type) (fun a a)) a]
                          [ [ { { { bad_name a } a } a } ds ] ds ]
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl id (all a (type) (fun a a)))
                    (abs a (type) (lam x a x))
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fMonoidEndo
                      (all a (type) [Monoid [(lam a (type) (fun a a)) a]])
                    )
                    (abs
                      a
                      (type)
                      [
                        [
                          { CConsMonoid [(lam a (type) (fun a a)) a] }
                          { fSemigroupEndo_c a }
                        ]
                        { id a }
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      appEndo
                      (all a (type) (fun [(lam a (type) (fun a a)) a] [(lam a (type) (fun a a)) a]))
                    )
                    (abs a (type) (lam ds [(lam a (type) (fun a a)) a] ds))
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fGeneric1TYPEDual
                      (all a (type) (fun [(lam a (type) a) a] [(lam a (type) a) a]))
                    )
                    (abs a (type) (lam x [(lam a (type) a) a] x))
                  )
                  (termbind
                    (strict)
                    (vardecl
                      foldl
                      (all t (fun (type) (type)) (all b (type) (all a (type) (fun [(lam t (fun (type) (type)) (all m (type) (all a (type) (fun [Monoid m] (fun (fun a m) (fun [t a] m)))))) t] (fun (fun b (fun a b)) (fun b (fun [t a] b)))))))
                    )
                    (abs
                      t
                      (fun (type) (type))
                      (abs
                        b
                        (type)
                        (abs
                          a
                          (type)
                          (lam
                            dFoldable
                            [(lam t (fun (type) (type)) (all m (type) (all a (type) (fun [Monoid m] (fun (fun a m) (fun [t a] m)))))) t]
                            (let
                              (nonrec)
                              (termbind
                                (nonstrict)
                                (vardecl
                                  dMonoid
                                  [Monoid [(lam a (type) a) [(lam a (type) (fun a a)) b]]]
                                )
                                [
                                  { fMonoidDual [(lam a (type) (fun a a)) b] }
                                  { fMonoidEndo b }
                                ]
                              )
                              (lam
                                f
                                (fun b (fun a b))
                                (lam
                                  z
                                  b
                                  (lam
                                    t
                                    [t a]
                                    [
                                      [
                                        { appEndo b }
                                        [
                                          {
                                            fGeneric1TYPEDual
                                            [(lam a (type) (fun a a)) b]
                                          }
                                          [
                                            [
                                              [
                                                {
                                                  {
                                                    dFoldable
                                                    [(lam a (type) a) [(lam a (type) (fun a a)) b]]
                                                  }
                                                  a
                                                }
                                                dMonoid
                                              ]
                                              (lam x a (lam y b [ [ f y ] x ]))
                                            ]
                                            t
                                          ]
                                        ]
                                      ]
                                      z
                                    ]
                                  )
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      length
                      (all t (fun (type) (type)) (all a (type) (fun [(lam t (fun (type) (type)) (all m (type) (all a (type) (fun [Monoid m] (fun (fun a m) (fun [t a] m)))))) t] (fun [t a] (con integer)))))
                    )
                    (abs
                      t
                      (fun (type) (type))
                      (abs
                        a
                        (type)
                        (lam
                          dFoldable
                          [(lam t (fun (type) (type)) (all m (type) (all a (type) (fun [Monoid m] (fun (fun a m) (fun [t a] m)))))) t]
                          [
                            [
                              [ { { { foldl t } (con integer) } a } dFoldable ]
                              (lam
                                c
                                (con integer)
                                (lam
                                  ds
                                  a
                                  [ [ (builtin addInteger) c ] (con integer 1) ]
                                )
                              )
                            ]
                            (con integer 0)
                          ]
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      proposalAccepted
                      (fun Params (fun [List (con bytestring)] Bool))
                    )
                    (lam
                      ds
                      Params
                      (lam
                        pks
                        [List (con bytestring)]
                        [
                          { [ Params_match ds ] Bool }
                          (lam
                            signatories
                            [List (con bytestring)]
                            (lam
                              numReq
                              (con integer)
                              [
                                [
                                  [
                                    { (builtin ifThenElse) Bool }
                                    [
                                      [
                                        (builtin greaterThanEqualsInteger)
                                        [
                                          [
                                            { { length List } (con bytestring) }
                                            fFoldableNil_cfoldMap
                                          ]
                                          [
                                            [
                                              [
                                                {
                                                  { foldr (con bytestring) }
                                                  [List (con bytestring)]
                                                }
                                                (lam
                                                  e
                                                  (con bytestring)
                                                  (lam
                                                    xs
                                                    [List (con bytestring)]
                                                    [
                                                      [
                                                        [
                                                          {
                                                            [
                                                              Bool_match
                                                              [
                                                                [
                                                                  [
                                                                    {
                                                                      {
                                                                        fFoldableNil_cfoldMap
                                                                        [(lam a (type) a) Bool]
                                                                      }
                                                                      (con bytestring)
                                                                    }
                                                                    [
                                                                      {
                                                                        fMonoidSum
                                                                        Bool
                                                                      }
                                                                      fAdditiveMonoidBool
                                                                    ]
                                                                  ]
                                                                  (lam
                                                                    pk
                                                                    (con bytestring)
                                                                    [
                                                                      [
                                                                        equalsByteString
                                                                        pk
                                                                      ]
                                                                      e
                                                                    ]
                                                                  )
                                                                ]
                                                                pks
                                                              ]
                                                            ]
                                                            (fun Unit [List (con bytestring)])
                                                          }
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              [
                                                                {
                                                                  Cons
                                                                  (con bytestring)
                                                                }
                                                                e
                                                              ]
                                                              xs
                                                            ]
                                                          )
                                                        ]
                                                        (lam thunk Unit xs)
                                                      ]
                                                      Unit
                                                    ]
                                                  )
                                                )
                                              ]
                                              { Nil (con bytestring) }
                                            ]
                                            signatories
                                          ]
                                        ]
                                      ]
                                      numReq
                                    ]
                                  ]
                                  True
                                ]
                                False
                              ]
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      transition
                      (fun Params (fun [State MSState] (fun Input [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]])))
                    )
                    (lam
                      params
                      Params
                      (lam
                        ds
                        [State MSState]
                        (lam
                          i
                          Input
                          [
                            {
                              [ { State_match MSState } ds ]
                              [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]]
                            }
                            (lam
                              ds
                              MSState
                              (lam
                                ds
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                [
                                  [
                                    [
                                      {
                                        [ MSState_match ds ]
                                        (fun Unit [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]])
                                      }
                                      (lam
                                        pmt
                                        Payment
                                        (lam
                                          pks
                                          [List (con bytestring)]
                                          (lam
                                            thunk
                                            Unit
                                            [
                                              [
                                                [
                                                  [
                                                    [
                                                      {
                                                        [ Input_match i ]
                                                        (fun Unit [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]])
                                                      }
                                                      (lam
                                                        pk
                                                        (con bytestring)
                                                        (lam
                                                          thunk
                                                          Unit
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  [
                                                                    Bool_match
                                                                    [
                                                                      [
                                                                        isSignatory
                                                                        pk
                                                                      ]
                                                                      params
                                                                    ]
                                                                  ]
                                                                  (fun Unit [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]])
                                                                }
                                                                (lam
                                                                  thunk
                                                                  Unit
                                                                  [
                                                                    [
                                                                      [
                                                                        {
                                                                          [
                                                                            Bool_match
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    {
                                                                                      fFoldableNil_cfoldMap
                                                                                      [(lam a (type) a) Bool]
                                                                                    }
                                                                                    (con bytestring)
                                                                                  }
                                                                                  [
                                                                                    {
                                                                                      fMonoidSum
                                                                                      Bool
                                                                                    }
                                                                                    fAdditiveMonoidBool
                                                                                  ]
                                                                                ]
                                                                                (lam
                                                                                  pk
                                                                                  (con bytestring)
                                                                                  [
                                                                                    [
                                                                                      equalsByteString
                                                                                      pk
                                                                                    ]
                                                                                    pk
                                                                                  ]
                                                                                )
                                                                              ]
                                                                              pks
                                                                            ]
                                                                          ]
                                                                          (fun Unit [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]])
                                                                        }
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          {
                                                                            Nothing
                                                                            [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                                          }
                                                                        )
                                                                      ]
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        [
                                                                          {
                                                                            Just
                                                                            [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                                          }
                                                                          [
                                                                            [
                                                                              {
                                                                                {
                                                                                  Tuple2
                                                                                  [[TxConstraints Void] Void]
                                                                                }
                                                                                [State MSState]
                                                                              }
                                                                              [
                                                                                {
                                                                                  {
                                                                                    mustBeSignedBy
                                                                                    Void
                                                                                  }
                                                                                  Void
                                                                                }
                                                                                pk
                                                                              ]
                                                                            ]
                                                                            [
                                                                              [
                                                                                {
                                                                                  State
                                                                                  MSState
                                                                                }
                                                                                [
                                                                                  [
                                                                                    CollectingSignatures
                                                                                    pmt
                                                                                  ]
                                                                                  [
                                                                                    [
                                                                                      {
                                                                                        Cons
                                                                                        (con bytestring)
                                                                                      }
                                                                                      pk
                                                                                    ]
                                                                                    pks
                                                                                  ]
                                                                                ]
                                                                              ]
                                                                              ds
                                                                            ]
                                                                          ]
                                                                        ]
                                                                      )
                                                                    ]
                                                                    Unit
                                                                  ]
                                                                )
                                                              ]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                {
                                                                  Nothing
                                                                  [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                                }
                                                              )
                                                            ]
                                                            Unit
                                                          ]
                                                        )
                                                      )
                                                    ]
                                                    (lam
                                                      thunk
                                                      Unit
                                                      [
                                                        {
                                                          Just
                                                          [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                        }
                                                        [
                                                          [
                                                            {
                                                              {
                                                                Tuple2
                                                                [[TxConstraints Void] Void]
                                                              }
                                                              [State MSState]
                                                            }
                                                            [
                                                              [
                                                                [
                                                                  {
                                                                    {
                                                                      TxConstraints
                                                                      Void
                                                                    }
                                                                    Void
                                                                  }
                                                                  [
                                                                    {
                                                                      build
                                                                      TxConstraint
                                                                    }
                                                                    (abs
                                                                      a
                                                                      (type)
                                                                      (lam
                                                                        c
                                                                        (fun TxConstraint (fun a a))
                                                                        (lam
                                                                          n
                                                                          a
                                                                          [
                                                                            [
                                                                              c
                                                                              [
                                                                                MustValidateIn
                                                                                [
                                                                                  [
                                                                                    {
                                                                                      Interval
                                                                                      (con integer)
                                                                                    }
                                                                                    [
                                                                                      [
                                                                                        {
                                                                                          LowerBound
                                                                                          (con integer)
                                                                                        }
                                                                                        [
                                                                                          {
                                                                                            Finite
                                                                                            (con integer)
                                                                                          }
                                                                                          [
                                                                                            {
                                                                                              [
                                                                                                Payment_match
                                                                                                pmt
                                                                                              ]
                                                                                              (con integer)
                                                                                            }
                                                                                            (lam
                                                                                              ds
                                                                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                              (lam
                                                                                                ds
                                                                                                (con bytestring)
                                                                                                (lam
                                                                                                  ds
                                                                                                  (con integer)
                                                                                                  ds
                                                                                                )
                                                                                              )
                                                                                            )
                                                                                          ]
                                                                                        ]
                                                                                      ]
                                                                                      True
                                                                                    ]
                                                                                  ]
                                                                                  [
                                                                                    [
                                                                                      {
                                                                                        UpperBound
                                                                                        (con integer)
                                                                                      }
                                                                                      {
                                                                                        PosInf
                                                                                        (con integer)
                                                                                      }
                                                                                    ]
                                                                                    True
                                                                                  ]
                                                                                ]
                                                                              ]
                                                                            ]
                                                                            n
                                                                          ]
                                                                        )
                                                                      )
                                                                    )
                                                                  ]
                                                                ]
                                                                {
                                                                  Nil
                                                                  [InputConstraint Void]
                                                                }
                                                              ]
                                                              {
                                                                Nil
                                                                [OutputConstraint Void]
                                                              }
                                                            ]
                                                          ]
                                                          [
                                                            [
                                                              { State MSState }
                                                              Holding
                                                            ]
                                                            ds
                                                          ]
                                                        ]
                                                      ]
                                                    )
                                                  ]
                                                  (lam
                                                    thunk
                                                    Unit
                                                    [
                                                      [
                                                        [
                                                          {
                                                            [
                                                              Bool_match
                                                              [
                                                                [
                                                                  proposalAccepted
                                                                  params
                                                                ]
                                                                pks
                                                              ]
                                                            ]
                                                            (fun Unit [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]])
                                                          }
                                                          (lam
                                                            thunk
                                                            Unit
                                                            (let
                                                              (nonrec)
                                                              (termbind
                                                                (nonstrict)
                                                                (vardecl
                                                                  paymentAmount
                                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                )
                                                                [
                                                                  {
                                                                    [
                                                                      Payment_match
                                                                      pmt
                                                                    ]
                                                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                  }
                                                                  (lam
                                                                    ds
                                                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                    (lam
                                                                      ds
                                                                      (con bytestring)
                                                                      (lam
                                                                        ds
                                                                        (con integer)
                                                                        ds
                                                                      )
                                                                    )
                                                                  )
                                                                ]
                                                              )
                                                              [
                                                                {
                                                                  Just
                                                                  [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                                }
                                                                [
                                                                  [
                                                                    {
                                                                      {
                                                                        Tuple2
                                                                        [[TxConstraints Void] Void]
                                                                      }
                                                                      [State MSState]
                                                                    }
                                                                    [
                                                                      [
                                                                        [
                                                                          {
                                                                            {
                                                                              TxConstraints
                                                                              Void
                                                                            }
                                                                            Void
                                                                          }
                                                                          [
                                                                            [
                                                                              [
                                                                                {
                                                                                  {
                                                                                    foldr
                                                                                    TxConstraint
                                                                                  }
                                                                                  [List TxConstraint]
                                                                                }
                                                                                {
                                                                                  Cons
                                                                                  TxConstraint
                                                                                }
                                                                              ]
                                                                              [
                                                                                {
                                                                                  build
                                                                                  TxConstraint
                                                                                }
                                                                                (abs
                                                                                  a
                                                                                  (type)
                                                                                  (lam
                                                                                    c
                                                                                    (fun TxConstraint (fun a a))
                                                                                    (lam
                                                                                      n
                                                                                      a
                                                                                      [
                                                                                        [
                                                                                          c
                                                                                          [
                                                                                            [
                                                                                              MustPayToPubKey
                                                                                              [
                                                                                                {
                                                                                                  [
                                                                                                    Payment_match
                                                                                                    pmt
                                                                                                  ]
                                                                                                  (con bytestring)
                                                                                                }
                                                                                                (lam
                                                                                                  ds
                                                                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                                  (lam
                                                                                                    ds
                                                                                                    (con bytestring)
                                                                                                    (lam
                                                                                                      ds
                                                                                                      (con integer)
                                                                                                      ds
                                                                                                    )
                                                                                                  )
                                                                                                )
                                                                                              ]
                                                                                            ]
                                                                                            paymentAmount
                                                                                          ]
                                                                                        ]
                                                                                        n
                                                                                      ]
                                                                                    )
                                                                                  )
                                                                                )
                                                                              ]
                                                                            ]
                                                                            [
                                                                              {
                                                                                build
                                                                                TxConstraint
                                                                              }
                                                                              (abs
                                                                                a
                                                                                (type)
                                                                                (lam
                                                                                  c
                                                                                  (fun TxConstraint (fun a a))
                                                                                  (lam
                                                                                    n
                                                                                    a
                                                                                    [
                                                                                      [
                                                                                        c
                                                                                        [
                                                                                          MustValidateIn
                                                                                          [
                                                                                            [
                                                                                              {
                                                                                                Interval
                                                                                                (con integer)
                                                                                              }
                                                                                              [
                                                                                                [
                                                                                                  {
                                                                                                    LowerBound
                                                                                                    (con integer)
                                                                                                  }
                                                                                                  {
                                                                                                    NegInf
                                                                                                    (con integer)
                                                                                                  }
                                                                                                ]
                                                                                                True
                                                                                              ]
                                                                                            ]
                                                                                            [
                                                                                              [
                                                                                                {
                                                                                                  UpperBound
                                                                                                  (con integer)
                                                                                                }
                                                                                                [
                                                                                                  {
                                                                                                    Finite
                                                                                                    (con integer)
                                                                                                  }
                                                                                                  [
                                                                                                    [
                                                                                                      (builtin
                                                                                                        subtractInteger
                                                                                                      )
                                                                                                      [
                                                                                                        {
                                                                                                          [
                                                                                                            Payment_match
                                                                                                            pmt
                                                                                                          ]
                                                                                                          (con integer)
                                                                                                        }
                                                                                                        (lam
                                                                                                          ds
                                                                                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                                          (lam
                                                                                                            ds
                                                                                                            (con bytestring)
                                                                                                            (lam
                                                                                                              ds
                                                                                                              (con integer)
                                                                                                              ds
                                                                                                            )
                                                                                                          )
                                                                                                        )
                                                                                                      ]
                                                                                                    ]
                                                                                                    (con
                                                                                                      integer
                                                                                                        1
                                                                                                    )
                                                                                                  ]
                                                                                                ]
                                                                                              ]
                                                                                              True
                                                                                            ]
                                                                                          ]
                                                                                        ]
                                                                                      ]
                                                                                      n
                                                                                    ]
                                                                                  )
                                                                                )
                                                                              )
                                                                            ]
                                                                          ]
                                                                        ]
                                                                        [
                                                                          [
                                                                            [
                                                                              {
                                                                                {
                                                                                  foldr
                                                                                  [InputConstraint Void]
                                                                                }
                                                                                [List [InputConstraint Void]]
                                                                              }
                                                                              {
                                                                                Cons
                                                                                [InputConstraint Void]
                                                                              }
                                                                            ]
                                                                            {
                                                                              Nil
                                                                              [InputConstraint Void]
                                                                            }
                                                                          ]
                                                                          {
                                                                            Nil
                                                                            [InputConstraint Void]
                                                                          }
                                                                        ]
                                                                      ]
                                                                      [
                                                                        [
                                                                          [
                                                                            {
                                                                              {
                                                                                foldr
                                                                                [OutputConstraint Void]
                                                                              }
                                                                              [List [OutputConstraint Void]]
                                                                            }
                                                                            {
                                                                              Cons
                                                                              [OutputConstraint Void]
                                                                            }
                                                                          ]
                                                                          {
                                                                            Nil
                                                                            [OutputConstraint Void]
                                                                          }
                                                                        ]
                                                                        {
                                                                          Nil
                                                                          [OutputConstraint Void]
                                                                        }
                                                                      ]
                                                                    ]
                                                                  ]
                                                                  [
                                                                    [
                                                                      {
                                                                        State
                                                                        MSState
                                                                      }
                                                                      Holding
                                                                    ]
                                                                    [
                                                                      [
                                                                        fAdditiveGroupValue
                                                                        ds
                                                                      ]
                                                                      paymentAmount
                                                                    ]
                                                                  ]
                                                                ]
                                                              ]
                                                            )
                                                          )
                                                        ]
                                                        (lam
                                                          thunk
                                                          Unit
                                                          {
                                                            Nothing
                                                            [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                          }
                                                        )
                                                      ]
                                                      Unit
                                                    ]
                                                  )
                                                ]
                                                (lam
                                                  ipv
                                                  Payment
                                                  (lam
                                                    thunk
                                                    Unit
                                                    {
                                                      Nothing
                                                      [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                    }
                                                  )
                                                )
                                              ]
                                              Unit
                                            ]
                                          )
                                        )
                                      )
                                    ]
                                    (lam
                                      thunk
                                      Unit
                                      [
                                        [
                                          [
                                            [
                                              [
                                                {
                                                  [ Input_match i ]
                                                  (fun Unit [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]])
                                                }
                                                (lam
                                                  default_arg0
                                                  (con bytestring)
                                                  (lam
                                                    thunk
                                                    Unit
                                                    {
                                                      Nothing
                                                      [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                    }
                                                  )
                                                )
                                              ]
                                              (lam
                                                thunk
                                                Unit
                                                {
                                                  Nothing
                                                  [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                }
                                              )
                                            ]
                                            (lam
                                              thunk
                                              Unit
                                              {
                                                Nothing
                                                [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                              }
                                            )
                                          ]
                                          (lam
                                            pmt
                                            Payment
                                            (lam
                                              thunk
                                              Unit
                                              [
                                                {
                                                  [ Payment_match pmt ]
                                                  [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]]
                                                }
                                                (lam
                                                  amt
                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                  (lam
                                                    ds
                                                    (con bytestring)
                                                    (lam
                                                      ds
                                                      (con integer)
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                Bool_match
                                                                [
                                                                  [
                                                                    [
                                                                      checkBinRel
                                                                      lessThanEqInteger
                                                                    ]
                                                                    amt
                                                                  ]
                                                                  ds
                                                                ]
                                                              ]
                                                              (fun Unit [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]])
                                                            }
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                {
                                                                  Just
                                                                  [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                                }
                                                                [
                                                                  [
                                                                    {
                                                                      {
                                                                        Tuple2
                                                                        [[TxConstraints Void] Void]
                                                                      }
                                                                      [State MSState]
                                                                    }
                                                                    {
                                                                      {
                                                                        fMonoidTxConstraints_cmempty
                                                                        Void
                                                                      }
                                                                      Void
                                                                    }
                                                                  ]
                                                                  [
                                                                    [
                                                                      {
                                                                        State
                                                                        MSState
                                                                      }
                                                                      [
                                                                        [
                                                                          CollectingSignatures
                                                                          pmt
                                                                        ]
                                                                        {
                                                                          Nil
                                                                          (con bytestring)
                                                                        }
                                                                      ]
                                                                    ]
                                                                    ds
                                                                  ]
                                                                ]
                                                              ]
                                                            )
                                                          ]
                                                          (lam
                                                            thunk
                                                            Unit
                                                            {
                                                              Nothing
                                                              [[Tuple2 [[TxConstraints Void] Void]] [State MSState]]
                                                            }
                                                          )
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  )
                                                )
                                              ]
                                            )
                                          )
                                        ]
                                        Unit
                                      ]
                                    )
                                  ]
                                  Unit
                                ]
                              )
                            )
                          ]
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl machine (fun Params [[StateMachine MSState] Input])
                    )
                    (lam
                      params
                      Params
                      [
                        [
                          [
                            [
                              { { StateMachine MSState } Input }
                              [ transition params ]
                            ]
                            (lam ds MSState False)
                          ]
                          { { mkStateMachine MSState } Input }
                        ]
                        { Nothing ThreadToken }
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl absurd (all a (type) (fun Void a)))
                    (abs a (type) (lam a Void { [ Void_match a ] a }))
                  )
                  (termbind
                    (strict)
                    (vardecl fToDataVoid_ctoBuiltinData (fun Void (con data)))
                    (lam v Void [ { absurd (con data) } v ])
                  )
                  (datatypebind
                    (datatype
                      (tyvardecl MultiplicativeMonoid (fun (type) (type)))
                      (tyvardecl a (type))
                      MultiplicativeMonoid_match
                      (vardecl
                        CConsMultiplicativeMonoid
                        (fun [(lam a (type) (fun a (fun a a))) a] (fun a [MultiplicativeMonoid a]))
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      p1MultiplicativeMonoid
                      (all a (type) (fun [MultiplicativeMonoid a] [(lam a (type) (fun a (fun a a))) a]))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        v
                        [MultiplicativeMonoid a]
                        [
                          {
                            [ { MultiplicativeMonoid_match a } v ]
                            [(lam a (type) (fun a (fun a a))) a]
                          }
                          (lam
                            v [(lam a (type) (fun a (fun a a))) a] (lam v a v)
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl one (all a (type) (fun [MultiplicativeMonoid a] a))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        v
                        [MultiplicativeMonoid a]
                        [
                          { [ { MultiplicativeMonoid_match a } v ] a }
                          (lam
                            v [(lam a (type) (fun a (fun a a))) a] (lam v a v)
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fMonoidProduct
                      (all a (type) (fun [MultiplicativeMonoid a] [Monoid [(lam a (type) a) a]]))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        v
                        [MultiplicativeMonoid a]
                        [
                          [
                            { CConsMonoid [(lam a (type) a) a] }
                            (lam
                              eta
                              [(lam a (type) a) a]
                              (lam
                                eta
                                [(lam a (type) a) a]
                                [
                                  [ [ { p1MultiplicativeMonoid a } v ] eta ] eta
                                ]
                              )
                            )
                          ]
                          [ { one a } v ]
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl bad_name (fun Bool (fun Bool Bool)))
                    (lam
                      ds
                      Bool
                      (lam
                        x
                        Bool
                        [
                          [
                            [
                              { [ Bool_match ds ] (fun Unit Bool) }
                              (lam thunk Unit x)
                            ]
                            (lam thunk Unit False)
                          ]
                          Unit
                        ]
                      )
                    )
                  )
                  (termbind
                    (nonstrict)
                    (vardecl
                      fMultiplicativeMonoidBool [MultiplicativeMonoid Bool]
                    )
                    [ [ { CConsMultiplicativeMonoid Bool } bad_name ] True ]
                  )
                  (termbind
                    (strict)
                    (vardecl fEqTxOutRef_c (fun TxOutRef (fun TxOutRef Bool)))
                    (lam
                      l
                      TxOutRef
                      (lam
                        r
                        TxOutRef
                        [
                          [
                            [
                              {
                                [
                                  Bool_match
                                  [
                                    [
                                      [
                                        { (builtin ifThenElse) Bool }
                                        [
                                          [
                                            (builtin equalsByteString)
                                            [
                                              {
                                                [ TxOutRef_match l ]
                                                (con bytestring)
                                              }
                                              (lam
                                                ds
                                                (con bytestring)
                                                (lam ds (con integer) ds)
                                              )
                                            ]
                                          ]
                                          [
                                            {
                                              [ TxOutRef_match r ]
                                              (con bytestring)
                                            }
                                            (lam
                                              ds
                                              (con bytestring)
                                              (lam ds (con integer) ds)
                                            )
                                          ]
                                        ]
                                      ]
                                      True
                                    ]
                                    False
                                  ]
                                ]
                                (fun Unit Bool)
                              }
                              (lam
                                thunk
                                Unit
                                [
                                  [
                                    [
                                      { (builtin ifThenElse) Bool }
                                      [
                                        [
                                          (builtin equalsInteger)
                                          [
                                            {
                                              [ TxOutRef_match l ] (con integer)
                                            }
                                            (lam
                                              ds
                                              (con bytestring)
                                              (lam ds (con integer) ds)
                                            )
                                          ]
                                        ]
                                        [
                                          { [ TxOutRef_match r ] (con integer) }
                                          (lam
                                            ds
                                            (con bytestring)
                                            (lam ds (con integer) ds)
                                          )
                                        ]
                                      ]
                                    ]
                                    True
                                  ]
                                  False
                                ]
                              )
                            ]
                            (lam thunk Unit False)
                          ]
                          Unit
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      checkOwnInputConstraint
                      (all a (type) (fun ScriptContext (fun [InputConstraint a] Bool)))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        ds
                        ScriptContext
                        (lam
                          ds
                          [InputConstraint a]
                          [
                            { [ ScriptContext_match ds ] Bool }
                            (lam
                              ds
                              TxInfo
                              (lam
                                ds
                                ScriptPurpose
                                [
                                  { [ { InputConstraint_match a } ds ] Bool }
                                  (lam
                                    ds
                                    a
                                    (lam
                                      ds
                                      TxOutRef
                                      [
                                        { [ TxInfo_match ds ] Bool }
                                        (lam
                                          ds
                                          [List TxInInfo]
                                          (lam
                                            ds
                                            [List TxOut]
                                            (lam
                                              ds
                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                              (lam
                                                ds
                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                (lam
                                                  ds
                                                  [List DCert]
                                                  (lam
                                                    ds
                                                    [List [[Tuple2 StakingCredential] (con integer)]]
                                                    (lam
                                                      ds
                                                      [Interval (con integer)]
                                                      (lam
                                                        ds
                                                        [List (con bytestring)]
                                                        (lam
                                                          ds
                                                          [List [[Tuple2 (con bytestring)] (con data)]]
                                                          (lam
                                                            ds
                                                            (con bytestring)
                                                            [
                                                              [
                                                                [
                                                                  {
                                                                    [
                                                                      Bool_match
                                                                      [
                                                                        [
                                                                          [
                                                                            {
                                                                              {
                                                                                fFoldableNil_cfoldMap
                                                                                [(lam a (type) a) Bool]
                                                                              }
                                                                              TxInInfo
                                                                            }
                                                                            [
                                                                              {
                                                                                fMonoidSum
                                                                                Bool
                                                                              }
                                                                              fAdditiveMonoidBool
                                                                            ]
                                                                          ]
                                                                          (lam
                                                                            ds
                                                                            TxInInfo
                                                                            [
                                                                              {
                                                                                [
                                                                                  TxInInfo_match
                                                                                  ds
                                                                                ]
                                                                                Bool
                                                                              }
                                                                              (lam
                                                                                ds
                                                                                TxOutRef
                                                                                (lam
                                                                                  ds
                                                                                  TxOut
                                                                                  [
                                                                                    [
                                                                                      fEqTxOutRef_c
                                                                                      ds
                                                                                    ]
                                                                                    ds
                                                                                  ]
                                                                                )
                                                                              )
                                                                            ]
                                                                          )
                                                                        ]
                                                                        ds
                                                                      ]
                                                                    ]
                                                                    (fun Unit Bool)
                                                                  }
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    True
                                                                  )
                                                                ]
                                                                (lam
                                                                  thunk
                                                                  Unit
                                                                  [
                                                                    [
                                                                      {
                                                                        (builtin
                                                                          chooseUnit
                                                                        )
                                                                        Bool
                                                                      }
                                                                      [
                                                                        (builtin
                                                                          trace
                                                                        )
                                                                        (con
                                                                          string
                                                                            "Input constraint"
                                                                        )
                                                                      ]
                                                                    ]
                                                                    False
                                                                  ]
                                                                )
                                                              ]
                                                              Unit
                                                            ]
                                                          )
                                                        )
                                                      )
                                                    )
                                                  )
                                                )
                                              )
                                            )
                                          )
                                        )
                                      ]
                                    )
                                  )
                                ]
                              )
                            )
                          ]
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fSemigroupFirst_c
                      (all a (type) (fun [(lam a (type) [Maybe a]) a] (fun [(lam a (type) [Maybe a]) a] [(lam a (type) [Maybe a]) a])))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        ds
                        [(lam a (type) [Maybe a]) a]
                        (lam
                          b
                          [(lam a (type) [Maybe a]) a]
                          [
                            [
                              [
                                {
                                  [ { Maybe_match a } ds ]
                                  (fun Unit [(lam a (type) [Maybe a]) a])
                                }
                                (lam ipv a (lam thunk Unit ds))
                              ]
                              (lam thunk Unit b)
                            ]
                            Unit
                          ]
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fMonoidFirst
                      (all a (type) [Monoid [(lam a (type) [Maybe a]) a]])
                    )
                    (abs
                      a
                      (type)
                      [
                        [
                          { CConsMonoid [(lam a (type) [Maybe a]) a] }
                          { fSemigroupFirst_c a }
                        ]
                        { Nothing a }
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      findDatumHash
                      (fun (con data) (fun TxInfo [Maybe (con bytestring)]))
                    )
                    (lam
                      ds
                      (con data)
                      (lam
                        ds
                        TxInfo
                        [
                          { [ TxInfo_match ds ] [Maybe (con bytestring)] }
                          (lam
                            ds
                            [List TxInInfo]
                            (lam
                              ds
                              [List TxOut]
                              (lam
                                ds
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                (lam
                                  ds
                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                  (lam
                                    ds
                                    [List DCert]
                                    (lam
                                      ds
                                      [List [[Tuple2 StakingCredential] (con integer)]]
                                      (lam
                                        ds
                                        [Interval (con integer)]
                                        (lam
                                          ds
                                          [List (con bytestring)]
                                          (lam
                                            ds
                                            [List [[Tuple2 (con bytestring)] (con data)]]
                                            (lam
                                              ds
                                              (con bytestring)
                                              [
                                                [
                                                  [
                                                    {
                                                      [
                                                        {
                                                          Maybe_match
                                                          [[Tuple2 (con bytestring)] (con data)]
                                                        }
                                                        [
                                                          [
                                                            [
                                                              {
                                                                {
                                                                  fFoldableNil_cfoldMap
                                                                  [(lam a (type) [Maybe a]) [[Tuple2 (con bytestring)] (con data)]]
                                                                }
                                                                [[Tuple2 (con bytestring)] (con data)]
                                                              }
                                                              {
                                                                fMonoidFirst
                                                                [[Tuple2 (con bytestring)] (con data)]
                                                              }
                                                            ]
                                                            (lam
                                                              x
                                                              [[Tuple2 (con bytestring)] (con data)]
                                                              [
                                                                {
                                                                  [
                                                                    {
                                                                      {
                                                                        Tuple2_match
                                                                        (con bytestring)
                                                                      }
                                                                      (con data)
                                                                    }
                                                                    x
                                                                  ]
                                                                  [Maybe [[Tuple2 (con bytestring)] (con data)]]
                                                                }
                                                                (lam
                                                                  ds
                                                                  (con bytestring)
                                                                  (lam
                                                                    ds
                                                                    (con data)
                                                                    [
                                                                      [
                                                                        [
                                                                          {
                                                                            [
                                                                              Bool_match
                                                                              [
                                                                                [
                                                                                  [
                                                                                    {
                                                                                      (builtin
                                                                                        ifThenElse
                                                                                      )
                                                                                      Bool
                                                                                    }
                                                                                    [
                                                                                      [
                                                                                        (builtin
                                                                                          equalsData
                                                                                        )
                                                                                        ds
                                                                                      ]
                                                                                      ds
                                                                                    ]
                                                                                  ]
                                                                                  True
                                                                                ]
                                                                                False
                                                                              ]
                                                                            ]
                                                                            (fun Unit [Maybe [[Tuple2 (con bytestring)] (con data)]])
                                                                          }
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            [
                                                                              {
                                                                                Just
                                                                                [[Tuple2 (con bytestring)] (con data)]
                                                                              }
                                                                              x
                                                                            ]
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          {
                                                                            Nothing
                                                                            [[Tuple2 (con bytestring)] (con data)]
                                                                          }
                                                                        )
                                                                      ]
                                                                      Unit
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                            )
                                                          ]
                                                          ds
                                                        ]
                                                      ]
                                                      (fun Unit [Maybe (con bytestring)])
                                                    }
                                                    (lam
                                                      a
                                                      [[Tuple2 (con bytestring)] (con data)]
                                                      (lam
                                                        thunk
                                                        Unit
                                                        [
                                                          {
                                                            Just
                                                            (con bytestring)
                                                          }
                                                          [
                                                            {
                                                              [
                                                                {
                                                                  {
                                                                    Tuple2_match
                                                                    (con bytestring)
                                                                  }
                                                                  (con data)
                                                                }
                                                                a
                                                              ]
                                                              (con bytestring)
                                                            }
                                                            (lam
                                                              a
                                                              (con bytestring)
                                                              (lam
                                                                ds (con data) a
                                                              )
                                                            )
                                                          ]
                                                        ]
                                                      )
                                                    )
                                                  ]
                                                  (lam
                                                    thunk
                                                    Unit
                                                    { Nothing (con bytestring) }
                                                  )
                                                ]
                                                Unit
                                              ]
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fEqCredential_c (fun Credential (fun Credential Bool))
                    )
                    (lam
                      ds
                      Credential
                      (lam
                        ds
                        Credential
                        [
                          [
                            { [ Credential_match ds ] Bool }
                            (lam
                              l
                              (con bytestring)
                              [
                                [
                                  { [ Credential_match ds ] Bool }
                                  (lam
                                    r
                                    (con bytestring)
                                    [ [ equalsByteString l ] r ]
                                  )
                                ]
                                (lam ipv (con bytestring) False)
                              ]
                            )
                          ]
                          (lam
                            a
                            (con bytestring)
                            [
                              [
                                { [ Credential_match ds ] Bool }
                                (lam ipv (con bytestring) False)
                              ]
                              (lam
                                a (con bytestring) [ [ equalsByteString a ] a ]
                              )
                            ]
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      equalsInteger (fun (con integer) (fun (con integer) Bool))
                    )
                    (lam
                      x
                      (con integer)
                      (lam
                        y
                        (con integer)
                        [
                          [
                            [
                              { (builtin ifThenElse) Bool }
                              [ [ (builtin equalsInteger) x ] y ]
                            ]
                            True
                          ]
                          False
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fEqStakingCredential_c
                      (fun StakingCredential (fun StakingCredential Bool))
                    )
                    (lam
                      ds
                      StakingCredential
                      (lam
                        ds
                        StakingCredential
                        [
                          [
                            { [ StakingCredential_match ds ] Bool }
                            (lam
                              l
                              Credential
                              [
                                [
                                  { [ StakingCredential_match ds ] Bool }
                                  (lam r Credential [ [ fEqCredential_c l ] r ])
                                ]
                                (lam
                                  ipv
                                  (con integer)
                                  (lam
                                    ipv
                                    (con integer)
                                    (lam ipv (con integer) False)
                                  )
                                )
                              ]
                            )
                          ]
                          (lam
                            a
                            (con integer)
                            (lam
                              b
                              (con integer)
                              (lam
                                c
                                (con integer)
                                [
                                  [
                                    { [ StakingCredential_match ds ] Bool }
                                    (lam ipv Credential False)
                                  ]
                                  (lam
                                    a
                                    (con integer)
                                    (lam
                                      b
                                      (con integer)
                                      (lam
                                        c
                                        (con integer)
                                        [
                                          [
                                            [
                                              {
                                                [
                                                  Bool_match
                                                  [
                                                    [
                                                      [
                                                        {
                                                          (builtin ifThenElse)
                                                          Bool
                                                        }
                                                        [
                                                          [
                                                            (builtin
                                                              equalsInteger
                                                            )
                                                            a
                                                          ]
                                                          a
                                                        ]
                                                      ]
                                                      True
                                                    ]
                                                    False
                                                  ]
                                                ]
                                                (fun Unit Bool)
                                              }
                                              (lam
                                                thunk
                                                Unit
                                                [
                                                  [
                                                    [
                                                      {
                                                        [
                                                          Bool_match
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  (builtin
                                                                    ifThenElse
                                                                  )
                                                                  Bool
                                                                }
                                                                [
                                                                  [
                                                                    (builtin
                                                                      equalsInteger
                                                                    )
                                                                    b
                                                                  ]
                                                                  b
                                                                ]
                                                              ]
                                                              True
                                                            ]
                                                            False
                                                          ]
                                                        ]
                                                        (fun Unit Bool)
                                                      }
                                                      (lam
                                                        thunk
                                                        Unit
                                                        [
                                                          [ equalsInteger c ] c
                                                        ]
                                                      )
                                                    ]
                                                    (lam thunk Unit False)
                                                  ]
                                                  Unit
                                                ]
                                              )
                                            ]
                                            (lam thunk Unit False)
                                          ]
                                          Unit
                                        ]
                                      )
                                    )
                                  )
                                ]
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl fEqAddress_c (fun Address (fun Address Bool)))
                    (lam
                      ds
                      Address
                      (lam
                        ds
                        Address
                        [
                          { [ Address_match ds ] Bool }
                          (lam
                            cred
                            Credential
                            (lam
                              stakingCred
                              [Maybe StakingCredential]
                              [
                                { [ Address_match ds ] Bool }
                                (lam
                                  cred
                                  Credential
                                  (lam
                                    stakingCred
                                    [Maybe StakingCredential]
                                    (let
                                      (nonrec)
                                      (termbind
                                        (nonstrict)
                                        (vardecl j Bool)
                                        [
                                          [
                                            [
                                              {
                                                [
                                                  {
                                                    Maybe_match
                                                    StakingCredential
                                                  }
                                                  stakingCred
                                                ]
                                                (fun Unit Bool)
                                              }
                                              (lam
                                                a
                                                StakingCredential
                                                (lam
                                                  thunk
                                                  Unit
                                                  [
                                                    [
                                                      [
                                                        {
                                                          [
                                                            {
                                                              Maybe_match
                                                              StakingCredential
                                                            }
                                                            stakingCred
                                                          ]
                                                          (fun Unit Bool)
                                                        }
                                                        (lam
                                                          a
                                                          StakingCredential
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              [
                                                                fEqStakingCredential_c
                                                                a
                                                              ]
                                                              a
                                                            ]
                                                          )
                                                        )
                                                      ]
                                                      (lam thunk Unit False)
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              )
                                            ]
                                            (lam
                                              thunk
                                              Unit
                                              [
                                                [
                                                  [
                                                    {
                                                      [
                                                        {
                                                          Maybe_match
                                                          StakingCredential
                                                        }
                                                        stakingCred
                                                      ]
                                                      (fun Unit Bool)
                                                    }
                                                    (lam
                                                      ipv
                                                      StakingCredential
                                                      (lam thunk Unit False)
                                                    )
                                                  ]
                                                  (lam thunk Unit True)
                                                ]
                                                Unit
                                              ]
                                            )
                                          ]
                                          Unit
                                        ]
                                      )
                                      [
                                        [
                                          { [ Credential_match cred ] Bool }
                                          (lam
                                            l
                                            (con bytestring)
                                            [
                                              [
                                                {
                                                  [ Credential_match cred ] Bool
                                                }
                                                (lam
                                                  r
                                                  (con bytestring)
                                                  [
                                                    [
                                                      [
                                                        {
                                                          [
                                                            Bool_match
                                                            [
                                                              [
                                                                [
                                                                  {
                                                                    (builtin
                                                                      ifThenElse
                                                                    )
                                                                    Bool
                                                                  }
                                                                  [
                                                                    [
                                                                      (builtin
                                                                        equalsByteString
                                                                      )
                                                                      l
                                                                    ]
                                                                    r
                                                                  ]
                                                                ]
                                                                True
                                                              ]
                                                              False
                                                            ]
                                                          ]
                                                          (fun Unit Bool)
                                                        }
                                                        (lam thunk Unit j)
                                                      ]
                                                      (lam thunk Unit False)
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              ]
                                              (lam ipv (con bytestring) False)
                                            ]
                                          )
                                        ]
                                        (lam
                                          a
                                          (con bytestring)
                                          [
                                            [
                                              { [ Credential_match cred ] Bool }
                                              (lam ipv (con bytestring) False)
                                            ]
                                            (lam
                                              a
                                              (con bytestring)
                                              [
                                                [
                                                  [
                                                    {
                                                      [
                                                        Bool_match
                                                        [
                                                          [
                                                            [
                                                              {
                                                                (builtin
                                                                  ifThenElse
                                                                )
                                                                Bool
                                                              }
                                                              [
                                                                [
                                                                  (builtin
                                                                    equalsByteString
                                                                  )
                                                                  a
                                                                ]
                                                                a
                                                              ]
                                                            ]
                                                            True
                                                          ]
                                                          False
                                                        ]
                                                      ]
                                                      (fun Unit Bool)
                                                    }
                                                    (lam thunk Unit j)
                                                  ]
                                                  (lam thunk Unit False)
                                                ]
                                                Unit
                                              ]
                                            )
                                          ]
                                        )
                                      ]
                                    )
                                  )
                                )
                              ]
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl error (all a (type) (fun (con unit) a)))
                    (abs a (type) (lam thunk (con unit) (error a)))
                  )
                  (termbind
                    (strict)
                    (vardecl findOwnInput (fun ScriptContext [Maybe TxInInfo]))
                    (lam
                      ds
                      ScriptContext
                      [
                        { [ ScriptContext_match ds ] [Maybe TxInInfo] }
                        (lam
                          ds
                          TxInfo
                          (lam
                            ds
                            ScriptPurpose
                            [
                              { [ TxInfo_match ds ] [Maybe TxInInfo] }
                              (lam
                                ds
                                [List TxInInfo]
                                (lam
                                  ds
                                  [List TxOut]
                                  (lam
                                    ds
                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                    (lam
                                      ds
                                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                      (lam
                                        ds
                                        [List DCert]
                                        (lam
                                          ds
                                          [List [[Tuple2 StakingCredential] (con integer)]]
                                          (lam
                                            ds
                                            [Interval (con integer)]
                                            (lam
                                              ds
                                              [List (con bytestring)]
                                              (lam
                                                ds
                                                [List [[Tuple2 (con bytestring)] (con data)]]
                                                (lam
                                                  ds
                                                  (con bytestring)
                                                  [
                                                    [
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                ScriptPurpose_match
                                                                ds
                                                              ]
                                                              (fun Unit [Maybe TxInInfo])
                                                            }
                                                            (lam
                                                              default_arg0
                                                              DCert
                                                              (lam
                                                                thunk
                                                                Unit
                                                                {
                                                                  Nothing
                                                                  TxInInfo
                                                                }
                                                              )
                                                            )
                                                          ]
                                                          (lam
                                                            default_arg0
                                                            (con bytestring)
                                                            (lam
                                                              thunk
                                                              Unit
                                                              {
                                                                Nothing TxInInfo
                                                              }
                                                            )
                                                          )
                                                        ]
                                                        (lam
                                                          default_arg0
                                                          StakingCredential
                                                          (lam
                                                            thunk
                                                            Unit
                                                            { Nothing TxInInfo }
                                                          )
                                                        )
                                                      ]
                                                      (lam
                                                        txOutRef
                                                        TxOutRef
                                                        (lam
                                                          thunk
                                                          Unit
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  {
                                                                    fFoldableNil_cfoldMap
                                                                    [(lam a (type) [Maybe a]) TxInInfo]
                                                                  }
                                                                  TxInInfo
                                                                }
                                                                {
                                                                  fMonoidFirst
                                                                  TxInInfo
                                                                }
                                                              ]
                                                              (lam
                                                                x
                                                                TxInInfo
                                                                [
                                                                  {
                                                                    [
                                                                      TxInInfo_match
                                                                      x
                                                                    ]
                                                                    [Maybe TxInInfo]
                                                                  }
                                                                  (lam
                                                                    ds
                                                                    TxOutRef
                                                                    (lam
                                                                      ds
                                                                      TxOut
                                                                      [
                                                                        [
                                                                          [
                                                                            {
                                                                              [
                                                                                Bool_match
                                                                                [
                                                                                  [
                                                                                    fEqTxOutRef_c
                                                                                    ds
                                                                                  ]
                                                                                  txOutRef
                                                                                ]
                                                                              ]
                                                                              (fun Unit [Maybe TxInInfo])
                                                                            }
                                                                            (lam
                                                                              thunk
                                                                              Unit
                                                                              [
                                                                                {
                                                                                  Just
                                                                                  TxInInfo
                                                                                }
                                                                                x
                                                                              ]
                                                                            )
                                                                          ]
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            {
                                                                              Nothing
                                                                              TxInInfo
                                                                            }
                                                                          )
                                                                        ]
                                                                        Unit
                                                                      ]
                                                                    )
                                                                  )
                                                                ]
                                                              )
                                                            ]
                                                            ds
                                                          ]
                                                        )
                                                      )
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            ]
                          )
                        )
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      getContinuingOutputs (fun ScriptContext [List TxOut])
                    )
                    (lam
                      ctx
                      ScriptContext
                      [
                        [
                          [
                            {
                              [ { Maybe_match TxInInfo } [ findOwnInput ctx ] ]
                              (fun Unit [List TxOut])
                            }
                            (lam
                              ds
                              TxInInfo
                              (lam
                                thunk
                                Unit
                                [
                                  { [ TxInInfo_match ds ] [List TxOut] }
                                  (lam
                                    ds
                                    TxOutRef
                                    (lam
                                      ds
                                      TxOut
                                      [
                                        { [ TxOut_match ds ] [List TxOut] }
                                        (lam
                                          ds
                                          Address
                                          (lam
                                            ds
                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                            (lam
                                              ds
                                              [Maybe (con bytestring)]
                                              [
                                                {
                                                  [ ScriptContext_match ctx ]
                                                  [List TxOut]
                                                }
                                                (lam
                                                  ds
                                                  TxInfo
                                                  (lam
                                                    ds
                                                    ScriptPurpose
                                                    [
                                                      {
                                                        [ TxInfo_match ds ]
                                                        [List TxOut]
                                                      }
                                                      (lam
                                                        ds
                                                        [List TxInInfo]
                                                        (lam
                                                          ds
                                                          [List TxOut]
                                                          (lam
                                                            ds
                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                            (lam
                                                              ds
                                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                              (lam
                                                                ds
                                                                [List DCert]
                                                                (lam
                                                                  ds
                                                                  [List [[Tuple2 StakingCredential] (con integer)]]
                                                                  (lam
                                                                    ds
                                                                    [Interval (con integer)]
                                                                    (lam
                                                                      ds
                                                                      [List (con bytestring)]
                                                                      (lam
                                                                        ds
                                                                        [List [[Tuple2 (con bytestring)] (con data)]]
                                                                        (lam
                                                                          ds
                                                                          (con bytestring)
                                                                          [
                                                                            [
                                                                              [
                                                                                {
                                                                                  {
                                                                                    foldr
                                                                                    TxOut
                                                                                  }
                                                                                  [List TxOut]
                                                                                }
                                                                                (lam
                                                                                  e
                                                                                  TxOut
                                                                                  (lam
                                                                                    xs
                                                                                    [List TxOut]
                                                                                    [
                                                                                      {
                                                                                        [
                                                                                          TxOut_match
                                                                                          e
                                                                                        ]
                                                                                        [List TxOut]
                                                                                      }
                                                                                      (lam
                                                                                        ds
                                                                                        Address
                                                                                        (lam
                                                                                          ds
                                                                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                          (lam
                                                                                            ds
                                                                                            [Maybe (con bytestring)]
                                                                                            [
                                                                                              [
                                                                                                [
                                                                                                  {
                                                                                                    [
                                                                                                      Bool_match
                                                                                                      [
                                                                                                        [
                                                                                                          fEqAddress_c
                                                                                                          ds
                                                                                                        ]
                                                                                                        ds
                                                                                                      ]
                                                                                                    ]
                                                                                                    (fun Unit [List TxOut])
                                                                                                  }
                                                                                                  (lam
                                                                                                    thunk
                                                                                                    Unit
                                                                                                    [
                                                                                                      [
                                                                                                        {
                                                                                                          Cons
                                                                                                          TxOut
                                                                                                        }
                                                                                                        e
                                                                                                      ]
                                                                                                      xs
                                                                                                    ]
                                                                                                  )
                                                                                                ]
                                                                                                (lam
                                                                                                  thunk
                                                                                                  Unit
                                                                                                  xs
                                                                                                )
                                                                                              ]
                                                                                              Unit
                                                                                            ]
                                                                                          )
                                                                                        )
                                                                                      )
                                                                                    ]
                                                                                  )
                                                                                )
                                                                              ]
                                                                              {
                                                                                Nil
                                                                                TxOut
                                                                              }
                                                                            ]
                                                                            ds
                                                                          ]
                                                                        )
                                                                      )
                                                                    )
                                                                  )
                                                                )
                                                              )
                                                            )
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  )
                                                )
                                              ]
                                            )
                                          )
                                        )
                                      ]
                                    )
                                  )
                                ]
                              )
                            )
                          ]
                          (lam
                            thunk
                            Unit
                            [
                              { error [List TxOut] }
                              [
                                {
                                  [
                                    Unit_match
                                    [
                                      [
                                        { (builtin chooseUnit) Unit }
                                        [
                                          (builtin trace)
                                          (con
                                            string
                                              "Can't get any continuing outputs"
                                          )
                                        ]
                                      ]
                                      Unit
                                    ]
                                  ]
                                  (con unit)
                                }
                                (con unit ())
                              ]
                            ]
                          )
                        ]
                        Unit
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      checkOwnOutputConstraint
                      (all o (type) (fun [(lam a (type) (fun a (con data))) o] (fun ScriptContext (fun [OutputConstraint o] Bool))))
                    )
                    (abs
                      o
                      (type)
                      (lam
                        dToData
                        [(lam a (type) (fun a (con data))) o]
                        (lam
                          ctx
                          ScriptContext
                          (lam
                            ds
                            [OutputConstraint o]
                            [
                              { [ ScriptContext_match ctx ] Bool }
                              (lam
                                ds
                                TxInfo
                                (lam
                                  ds
                                  ScriptPurpose
                                  [
                                    { [ { OutputConstraint_match o } ds ] Bool }
                                    (lam
                                      ds
                                      o
                                      (lam
                                        ds
                                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                        (let
                                          (nonrec)
                                          (termbind
                                            (nonstrict)
                                            (vardecl
                                              hsh [Maybe (con bytestring)]
                                            )
                                            [
                                              [ findDatumHash [ dToData ds ] ]
                                              ds
                                            ]
                                          )
                                          [
                                            [
                                              [
                                                {
                                                  [
                                                    Bool_match
                                                    [
                                                      [
                                                        [
                                                          {
                                                            {
                                                              fFoldableNil_cfoldMap
                                                              [(lam a (type) a) Bool]
                                                            }
                                                            TxOut
                                                          }
                                                          [
                                                            { fMonoidSum Bool }
                                                            fAdditiveMonoidBool
                                                          ]
                                                        ]
                                                        (lam
                                                          ds
                                                          TxOut
                                                          [
                                                            {
                                                              [ TxOut_match ds ]
                                                              Bool
                                                            }
                                                            (lam
                                                              ds
                                                              Address
                                                              (lam
                                                                ds
                                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                (lam
                                                                  ds
                                                                  [Maybe (con bytestring)]
                                                                  [
                                                                    [
                                                                      [
                                                                        {
                                                                          [
                                                                            {
                                                                              Maybe_match
                                                                              (con bytestring)
                                                                            }
                                                                            ds
                                                                          ]
                                                                          (fun Unit Bool)
                                                                        }
                                                                        (lam
                                                                          svh
                                                                          (con bytestring)
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    [
                                                                                      Bool_match
                                                                                      [
                                                                                        [
                                                                                          [
                                                                                            checkBinRel
                                                                                            equalsInteger
                                                                                          ]
                                                                                          ds
                                                                                        ]
                                                                                        ds
                                                                                      ]
                                                                                    ]
                                                                                    (fun Unit Bool)
                                                                                  }
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    [
                                                                                      [
                                                                                        [
                                                                                          {
                                                                                            [
                                                                                              {
                                                                                                Maybe_match
                                                                                                (con bytestring)
                                                                                              }
                                                                                              hsh
                                                                                            ]
                                                                                            (fun Unit Bool)
                                                                                          }
                                                                                          (lam
                                                                                            a
                                                                                            (con bytestring)
                                                                                            (lam
                                                                                              thunk
                                                                                              Unit
                                                                                              [
                                                                                                [
                                                                                                  equalsByteString
                                                                                                  a
                                                                                                ]
                                                                                                svh
                                                                                              ]
                                                                                            )
                                                                                          )
                                                                                        ]
                                                                                        (lam
                                                                                          thunk
                                                                                          Unit
                                                                                          False
                                                                                        )
                                                                                      ]
                                                                                      Unit
                                                                                    ]
                                                                                  )
                                                                                ]
                                                                                (lam
                                                                                  thunk
                                                                                  Unit
                                                                                  False
                                                                                )
                                                                              ]
                                                                              Unit
                                                                            ]
                                                                          )
                                                                        )
                                                                      ]
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        False
                                                                      )
                                                                    ]
                                                                    Unit
                                                                  ]
                                                                )
                                                              )
                                                            )
                                                          ]
                                                        )
                                                      ]
                                                      [
                                                        getContinuingOutputs ctx
                                                      ]
                                                    ]
                                                  ]
                                                  (fun Unit Bool)
                                                }
                                                (lam thunk Unit True)
                                              ]
                                              (lam
                                                thunk
                                                Unit
                                                [
                                                  [
                                                    {
                                                      (builtin chooseUnit) Bool
                                                    }
                                                    [
                                                      (builtin trace)
                                                      (con
                                                        string
                                                          "Output constraint"
                                                      )
                                                    ]
                                                  ]
                                                  False
                                                ]
                                              )
                                            ]
                                            Unit
                                          ]
                                        )
                                      )
                                    )
                                  ]
                                )
                              )
                            ]
                          )
                        )
                      )
                    )
                  )
                  (datatypebind
                    (datatype
                      (tyvardecl Ordering (type))

                      Ordering_match
                      (vardecl EQ Ordering)
                      (vardecl GT Ordering)
                      (vardecl LT Ordering)
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fOrdData_ccompare
                      (fun (con integer) (fun (con integer) Ordering))
                    )
                    (lam
                      x
                      (con integer)
                      (lam
                        y
                        (con integer)
                        [
                          [
                            [
                              {
                                [
                                  Bool_match
                                  [
                                    [
                                      [
                                        { (builtin ifThenElse) Bool }
                                        [ [ (builtin equalsInteger) x ] y ]
                                      ]
                                      True
                                    ]
                                    False
                                  ]
                                ]
                                (fun Unit Ordering)
                              }
                              (lam thunk Unit EQ)
                            ]
                            (lam
                              thunk
                              Unit
                              [
                                [
                                  [
                                    {
                                      [
                                        Bool_match
                                        [
                                          [
                                            [
                                              { (builtin ifThenElse) Bool }
                                              [
                                                [
                                                  (builtin lessThanEqualsInteger
                                                  )
                                                  x
                                                ]
                                                y
                                              ]
                                            ]
                                            True
                                          ]
                                          False
                                        ]
                                      ]
                                      (fun Unit Ordering)
                                    }
                                    (lam thunk Unit LT)
                                  ]
                                  (lam thunk Unit GT)
                                ]
                                Unit
                              ]
                            )
                          ]
                          Unit
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fOrdInteger_cmax
                      (fun (con integer) (fun (con integer) (con integer)))
                    )
                    (lam
                      x
                      (con integer)
                      (lam
                        y
                        (con integer)
                        [
                          [
                            [
                              {
                                [
                                  Bool_match
                                  [
                                    [
                                      [
                                        { (builtin ifThenElse) Bool }
                                        [
                                          [ (builtin lessThanEqualsInteger) x ]
                                          y
                                        ]
                                      ]
                                      True
                                    ]
                                    False
                                  ]
                                ]
                                (fun Unit (con integer))
                              }
                              (lam thunk Unit y)
                            ]
                            (lam thunk Unit x)
                          ]
                          Unit
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fOrdInteger_cmin
                      (fun (con integer) (fun (con integer) (con integer)))
                    )
                    (lam
                      x
                      (con integer)
                      (lam
                        y
                        (con integer)
                        [
                          [
                            [
                              {
                                [
                                  Bool_match
                                  [
                                    [
                                      [
                                        { (builtin ifThenElse) Bool }
                                        [
                                          [ (builtin lessThanEqualsInteger) x ]
                                          y
                                        ]
                                      ]
                                      True
                                    ]
                                    False
                                  ]
                                ]
                                (fun Unit (con integer))
                              }
                              (lam thunk Unit x)
                            ]
                            (lam thunk Unit y)
                          ]
                          Unit
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      greaterThanEqInteger
                      (fun (con integer) (fun (con integer) Bool))
                    )
                    (lam
                      x
                      (con integer)
                      (lam
                        y
                        (con integer)
                        [
                          [
                            [
                              { (builtin ifThenElse) Bool }
                              [ [ (builtin greaterThanEqualsInteger) x ] y ]
                            ]
                            True
                          ]
                          False
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      greaterThanInteger
                      (fun (con integer) (fun (con integer) Bool))
                    )
                    (lam
                      x
                      (con integer)
                      (lam
                        y
                        (con integer)
                        [
                          [
                            [
                              { (builtin ifThenElse) Bool }
                              [ [ (builtin greaterThanInteger) x ] y ]
                            ]
                            True
                          ]
                          False
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      lessThanInteger
                      (fun (con integer) (fun (con integer) Bool))
                    )
                    (lam
                      x
                      (con integer)
                      (lam
                        y
                        (con integer)
                        [
                          [
                            [
                              { (builtin ifThenElse) Bool }
                              [ [ (builtin lessThanInteger) x ] y ]
                            ]
                            True
                          ]
                          False
                        ]
                      )
                    )
                  )
                  (datatypebind
                    (datatype
                      (tyvardecl Ord (fun (type) (type)))
                      (tyvardecl a (type))
                      Ord_match
                      (vardecl
                        CConsOrd
                        (fun [(lam a (type) (fun a (fun a Bool))) a] (fun (fun a (fun a Ordering)) (fun (fun a (fun a Bool)) (fun (fun a (fun a Bool)) (fun (fun a (fun a Bool)) (fun (fun a (fun a Bool)) (fun (fun a (fun a a)) (fun (fun a (fun a a)) [Ord a]))))))))
                      )
                    )
                  )
                  (termbind
                    (nonstrict)
                    (vardecl fOrdPOSIXTime [Ord (con integer)])
                    [
                      [
                        [
                          [
                            [
                              [
                                [
                                  [ { CConsOrd (con integer) } equalsInteger ]
                                  fOrdData_ccompare
                                ]
                                lessThanInteger
                              ]
                              lessThanEqInteger
                            ]
                            greaterThanInteger
                          ]
                          greaterThanEqInteger
                        ]
                        fOrdInteger_cmax
                      ]
                      fOrdInteger_cmin
                    ]
                  )
                  (termbind
                    (strict)
                    (vardecl
                      compare
                      (all a (type) (fun [Ord a] (fun a (fun a Ordering))))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        v
                        [Ord a]
                        [
                          { [ { Ord_match a } v ] (fun a (fun a Ordering)) }
                          (lam
                            v
                            [(lam a (type) (fun a (fun a Bool))) a]
                            (lam
                              v
                              (fun a (fun a Ordering))
                              (lam
                                v
                                (fun a (fun a Bool))
                                (lam
                                  v
                                  (fun a (fun a Bool))
                                  (lam
                                    v
                                    (fun a (fun a Bool))
                                    (lam
                                      v
                                      (fun a (fun a Bool))
                                      (lam
                                        v
                                        (fun a (fun a a))
                                        (lam v (fun a (fun a a)) v)
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      hull_ccompare
                      (all a (type) (fun [Ord a] (fun [Extended a] (fun [Extended a] Ordering))))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        dOrd
                        [Ord a]
                        (lam
                          ds
                          [Extended a]
                          (lam
                            ds
                            [Extended a]
                            (let
                              (nonrec)
                              (termbind
                                (strict)
                                (vardecl fail (fun (all a (type) a) Ordering))
                                (lam ds (all a (type) a) (error Ordering))
                              )
                              [
                                [
                                  [
                                    [
                                      {
                                        [ { Extended_match a } ds ]
                                        (fun Unit Ordering)
                                      }
                                      (lam
                                        default_arg0
                                        a
                                        (lam
                                          thunk
                                          Unit
                                          [
                                            [
                                              [
                                                [
                                                  {
                                                    [ { Extended_match a } ds ]
                                                    (fun Unit Ordering)
                                                  }
                                                  (lam
                                                    default_arg0
                                                    a
                                                    (lam
                                                      thunk
                                                      Unit
                                                      (let
                                                        (nonrec)
                                                        (termbind
                                                          (strict)
                                                          (vardecl
                                                            fail
                                                            (fun (all a (type) a) Ordering)
                                                          )
                                                          (lam
                                                            ds
                                                            (all a (type) a)
                                                            [
                                                              [
                                                                [
                                                                  [
                                                                    {
                                                                      [
                                                                        {
                                                                          Extended_match
                                                                          a
                                                                        }
                                                                        ds
                                                                      ]
                                                                      (fun Unit Ordering)
                                                                    }
                                                                    (lam
                                                                      default_arg0
                                                                      a
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        [
                                                                          [
                                                                            [
                                                                              [
                                                                                {
                                                                                  [
                                                                                    {
                                                                                      Extended_match
                                                                                      a
                                                                                    }
                                                                                    ds
                                                                                  ]
                                                                                  (fun Unit Ordering)
                                                                                }
                                                                                (lam
                                                                                  l
                                                                                  a
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    [
                                                                                      [
                                                                                        [
                                                                                          [
                                                                                            {
                                                                                              [
                                                                                                {
                                                                                                  Extended_match
                                                                                                  a
                                                                                                }
                                                                                                ds
                                                                                              ]
                                                                                              (fun Unit Ordering)
                                                                                            }
                                                                                            (lam
                                                                                              r
                                                                                              a
                                                                                              (lam
                                                                                                thunk
                                                                                                Unit
                                                                                                [
                                                                                                  [
                                                                                                    [
                                                                                                      {
                                                                                                        compare
                                                                                                        a
                                                                                                      }
                                                                                                      dOrd
                                                                                                    ]
                                                                                                    l
                                                                                                  ]
                                                                                                  r
                                                                                                ]
                                                                                              )
                                                                                            )
                                                                                          ]
                                                                                          (lam
                                                                                            thunk
                                                                                            Unit
                                                                                            [
                                                                                              fail
                                                                                              (abs
                                                                                                e
                                                                                                (type)
                                                                                                (error
                                                                                                  e
                                                                                                )
                                                                                              )
                                                                                            ]
                                                                                          )
                                                                                        ]
                                                                                        (lam
                                                                                          thunk
                                                                                          Unit
                                                                                          [
                                                                                            fail
                                                                                            (abs
                                                                                              e
                                                                                              (type)
                                                                                              (error
                                                                                                e
                                                                                              )
                                                                                            )
                                                                                          ]
                                                                                        )
                                                                                      ]
                                                                                      Unit
                                                                                    ]
                                                                                  )
                                                                                )
                                                                              ]
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                [
                                                                                  fail
                                                                                  (abs
                                                                                    e
                                                                                    (type)
                                                                                    (error
                                                                                      e
                                                                                    )
                                                                                  )
                                                                                ]
                                                                              )
                                                                            ]
                                                                            (lam
                                                                              thunk
                                                                              Unit
                                                                              GT
                                                                            )
                                                                          ]
                                                                          Unit
                                                                        ]
                                                                      )
                                                                    )
                                                                  ]
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    [
                                                                      [
                                                                        [
                                                                          [
                                                                            {
                                                                              [
                                                                                {
                                                                                  Extended_match
                                                                                  a
                                                                                }
                                                                                ds
                                                                              ]
                                                                              (fun Unit Ordering)
                                                                            }
                                                                            (lam
                                                                              l
                                                                              a
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                [
                                                                                  [
                                                                                    [
                                                                                      [
                                                                                        {
                                                                                          [
                                                                                            {
                                                                                              Extended_match
                                                                                              a
                                                                                            }
                                                                                            ds
                                                                                          ]
                                                                                          (fun Unit Ordering)
                                                                                        }
                                                                                        (lam
                                                                                          r
                                                                                          a
                                                                                          (lam
                                                                                            thunk
                                                                                            Unit
                                                                                            [
                                                                                              [
                                                                                                [
                                                                                                  {
                                                                                                    compare
                                                                                                    a
                                                                                                  }
                                                                                                  dOrd
                                                                                                ]
                                                                                                l
                                                                                              ]
                                                                                              r
                                                                                            ]
                                                                                          )
                                                                                        )
                                                                                      ]
                                                                                      (lam
                                                                                        thunk
                                                                                        Unit
                                                                                        [
                                                                                          fail
                                                                                          (abs
                                                                                            e
                                                                                            (type)
                                                                                            (error
                                                                                              e
                                                                                            )
                                                                                          )
                                                                                        ]
                                                                                      )
                                                                                    ]
                                                                                    (lam
                                                                                      thunk
                                                                                      Unit
                                                                                      [
                                                                                        fail
                                                                                        (abs
                                                                                          e
                                                                                          (type)
                                                                                          (error
                                                                                            e
                                                                                          )
                                                                                        )
                                                                                      ]
                                                                                    )
                                                                                  ]
                                                                                  Unit
                                                                                ]
                                                                              )
                                                                            )
                                                                          ]
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            [
                                                                              fail
                                                                              (abs
                                                                                e
                                                                                (type)
                                                                                (error
                                                                                  e
                                                                                )
                                                                              )
                                                                            ]
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          GT
                                                                        )
                                                                      ]
                                                                      Unit
                                                                    ]
                                                                  )
                                                                ]
                                                                (lam
                                                                  thunk Unit LT
                                                                )
                                                              ]
                                                              Unit
                                                            ]
                                                          )
                                                        )
                                                        [
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  [
                                                                    {
                                                                      Extended_match
                                                                      a
                                                                    }
                                                                    ds
                                                                  ]
                                                                  (fun Unit Ordering)
                                                                }
                                                                (lam
                                                                  default_arg0
                                                                  a
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    [
                                                                      fail
                                                                      (abs
                                                                        e
                                                                        (type)
                                                                        (error e
                                                                        )
                                                                      )
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                [
                                                                  fail
                                                                  (abs
                                                                    e
                                                                    (type)
                                                                    (error e)
                                                                  )
                                                                ]
                                                              )
                                                            ]
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                [
                                                                  [
                                                                    [
                                                                      {
                                                                        [
                                                                          {
                                                                            Extended_match
                                                                            a
                                                                          }
                                                                          ds
                                                                        ]
                                                                        (fun Unit Ordering)
                                                                      }
                                                                      (lam
                                                                        default_arg0
                                                                        a
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          [
                                                                            fail
                                                                            (abs
                                                                              e
                                                                              (type)
                                                                              (error
                                                                                e
                                                                              )
                                                                            )
                                                                          ]
                                                                        )
                                                                      )
                                                                    ]
                                                                    (lam
                                                                      thunk
                                                                      Unit
                                                                      [
                                                                        fail
                                                                        (abs
                                                                          e
                                                                          (type)
                                                                          (error
                                                                            e
                                                                          )
                                                                        )
                                                                      ]
                                                                    )
                                                                  ]
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    EQ
                                                                  )
                                                                ]
                                                                Unit
                                                              ]
                                                            )
                                                          ]
                                                          Unit
                                                        ]
                                                      )
                                                    )
                                                  )
                                                ]
                                                (lam thunk Unit GT)
                                              ]
                                              (lam
                                                thunk
                                                Unit
                                                (let
                                                  (nonrec)
                                                  (termbind
                                                    (strict)
                                                    (vardecl
                                                      fail
                                                      (fun (all a (type) a) Ordering)
                                                    )
                                                    (lam
                                                      ds
                                                      (all a (type) a)
                                                      [
                                                        [
                                                          [
                                                            [
                                                              {
                                                                [
                                                                  {
                                                                    Extended_match
                                                                    a
                                                                  }
                                                                  ds
                                                                ]
                                                                (fun Unit Ordering)
                                                              }
                                                              (lam
                                                                default_arg0
                                                                a
                                                                (lam
                                                                  thunk
                                                                  Unit
                                                                  [
                                                                    [
                                                                      [
                                                                        [
                                                                          {
                                                                            [
                                                                              {
                                                                                Extended_match
                                                                                a
                                                                              }
                                                                              ds
                                                                            ]
                                                                            (fun Unit Ordering)
                                                                          }
                                                                          (lam
                                                                            l
                                                                            a
                                                                            (lam
                                                                              thunk
                                                                              Unit
                                                                              [
                                                                                [
                                                                                  [
                                                                                    [
                                                                                      {
                                                                                        [
                                                                                          {
                                                                                            Extended_match
                                                                                            a
                                                                                          }
                                                                                          ds
                                                                                        ]
                                                                                        (fun Unit Ordering)
                                                                                      }
                                                                                      (lam
                                                                                        r
                                                                                        a
                                                                                        (lam
                                                                                          thunk
                                                                                          Unit
                                                                                          [
                                                                                            [
                                                                                              [
                                                                                                {
                                                                                                  compare
                                                                                                  a
                                                                                                }
                                                                                                dOrd
                                                                                              ]
                                                                                              l
                                                                                            ]
                                                                                            r
                                                                                          ]
                                                                                        )
                                                                                      )
                                                                                    ]
                                                                                    (lam
                                                                                      thunk
                                                                                      Unit
                                                                                      [
                                                                                        fail
                                                                                        (abs
                                                                                          e
                                                                                          (type)
                                                                                          (error
                                                                                            e
                                                                                          )
                                                                                        )
                                                                                      ]
                                                                                    )
                                                                                  ]
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    [
                                                                                      fail
                                                                                      (abs
                                                                                        e
                                                                                        (type)
                                                                                        (error
                                                                                          e
                                                                                        )
                                                                                      )
                                                                                    ]
                                                                                  )
                                                                                ]
                                                                                Unit
                                                                              ]
                                                                            )
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          [
                                                                            fail
                                                                            (abs
                                                                              e
                                                                              (type)
                                                                              (error
                                                                                e
                                                                              )
                                                                            )
                                                                          ]
                                                                        )
                                                                      ]
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        GT
                                                                      )
                                                                    ]
                                                                    Unit
                                                                  ]
                                                                )
                                                              )
                                                            ]
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                [
                                                                  [
                                                                    [
                                                                      {
                                                                        [
                                                                          {
                                                                            Extended_match
                                                                            a
                                                                          }
                                                                          ds
                                                                        ]
                                                                        (fun Unit Ordering)
                                                                      }
                                                                      (lam
                                                                        l
                                                                        a
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          [
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    [
                                                                                      {
                                                                                        Extended_match
                                                                                        a
                                                                                      }
                                                                                      ds
                                                                                    ]
                                                                                    (fun Unit Ordering)
                                                                                  }
                                                                                  (lam
                                                                                    r
                                                                                    a
                                                                                    (lam
                                                                                      thunk
                                                                                      Unit
                                                                                      [
                                                                                        [
                                                                                          [
                                                                                            {
                                                                                              compare
                                                                                              a
                                                                                            }
                                                                                            dOrd
                                                                                          ]
                                                                                          l
                                                                                        ]
                                                                                        r
                                                                                      ]
                                                                                    )
                                                                                  )
                                                                                ]
                                                                                (lam
                                                                                  thunk
                                                                                  Unit
                                                                                  [
                                                                                    fail
                                                                                    (abs
                                                                                      e
                                                                                      (type)
                                                                                      (error
                                                                                        e
                                                                                      )
                                                                                    )
                                                                                  ]
                                                                                )
                                                                              ]
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                [
                                                                                  fail
                                                                                  (abs
                                                                                    e
                                                                                    (type)
                                                                                    (error
                                                                                      e
                                                                                    )
                                                                                  )
                                                                                ]
                                                                              )
                                                                            ]
                                                                            Unit
                                                                          ]
                                                                        )
                                                                      )
                                                                    ]
                                                                    (lam
                                                                      thunk
                                                                      Unit
                                                                      [
                                                                        fail
                                                                        (abs
                                                                          e
                                                                          (type)
                                                                          (error
                                                                            e
                                                                          )
                                                                        )
                                                                      ]
                                                                    )
                                                                  ]
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    GT
                                                                  )
                                                                ]
                                                                Unit
                                                              ]
                                                            )
                                                          ]
                                                          (lam thunk Unit LT)
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  )
                                                  [
                                                    [
                                                      [
                                                        [
                                                          {
                                                            [
                                                              {
                                                                Extended_match a
                                                              }
                                                              ds
                                                            ]
                                                            (fun Unit Ordering)
                                                          }
                                                          (lam
                                                            default_arg0
                                                            a
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                fail
                                                                (abs
                                                                  e
                                                                  (type)
                                                                  (error e)
                                                                )
                                                              ]
                                                            )
                                                          )
                                                        ]
                                                        (lam
                                                          thunk
                                                          Unit
                                                          [
                                                            fail
                                                            (abs
                                                              e (type) (error e)
                                                            )
                                                          ]
                                                        )
                                                      ]
                                                      (lam
                                                        thunk
                                                        Unit
                                                        [
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  [
                                                                    {
                                                                      Extended_match
                                                                      a
                                                                    }
                                                                    ds
                                                                  ]
                                                                  (fun Unit Ordering)
                                                                }
                                                                (lam
                                                                  default_arg0
                                                                  a
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    [
                                                                      fail
                                                                      (abs
                                                                        e
                                                                        (type)
                                                                        (error e
                                                                        )
                                                                      )
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                [
                                                                  fail
                                                                  (abs
                                                                    e
                                                                    (type)
                                                                    (error e)
                                                                  )
                                                                ]
                                                              )
                                                            ]
                                                            (lam thunk Unit EQ)
                                                          ]
                                                          Unit
                                                        ]
                                                      )
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              )
                                            ]
                                            Unit
                                          ]
                                        )
                                      )
                                    ]
                                    (lam
                                      thunk
                                      Unit
                                      [
                                        [
                                          [
                                            [
                                              {
                                                [ { Extended_match a } ds ]
                                                (fun Unit Ordering)
                                              }
                                              (lam
                                                default_arg0
                                                a
                                                (lam thunk Unit LT)
                                              )
                                            ]
                                            (lam thunk Unit EQ)
                                          ]
                                          (lam thunk Unit LT)
                                        ]
                                        Unit
                                      ]
                                    )
                                  ]
                                  (lam
                                    thunk
                                    Unit
                                    [
                                      [
                                        [
                                          [
                                            {
                                              [ { Extended_match a } ds ]
                                              (fun Unit Ordering)
                                            }
                                            (lam
                                              default_arg0
                                              a
                                              (lam
                                                thunk
                                                Unit
                                                (let
                                                  (nonrec)
                                                  (termbind
                                                    (strict)
                                                    (vardecl
                                                      fail
                                                      (fun (all a (type) a) Ordering)
                                                    )
                                                    (lam
                                                      ds
                                                      (all a (type) a)
                                                      [
                                                        [
                                                          [
                                                            [
                                                              {
                                                                [
                                                                  {
                                                                    Extended_match
                                                                    a
                                                                  }
                                                                  ds
                                                                ]
                                                                (fun Unit Ordering)
                                                              }
                                                              (lam
                                                                default_arg0
                                                                a
                                                                (lam
                                                                  thunk
                                                                  Unit
                                                                  [
                                                                    [
                                                                      [
                                                                        [
                                                                          {
                                                                            [
                                                                              {
                                                                                Extended_match
                                                                                a
                                                                              }
                                                                              ds
                                                                            ]
                                                                            (fun Unit Ordering)
                                                                          }
                                                                          (lam
                                                                            l
                                                                            a
                                                                            (lam
                                                                              thunk
                                                                              Unit
                                                                              [
                                                                                [
                                                                                  [
                                                                                    [
                                                                                      {
                                                                                        [
                                                                                          {
                                                                                            Extended_match
                                                                                            a
                                                                                          }
                                                                                          ds
                                                                                        ]
                                                                                        (fun Unit Ordering)
                                                                                      }
                                                                                      (lam
                                                                                        r
                                                                                        a
                                                                                        (lam
                                                                                          thunk
                                                                                          Unit
                                                                                          [
                                                                                            [
                                                                                              [
                                                                                                {
                                                                                                  compare
                                                                                                  a
                                                                                                }
                                                                                                dOrd
                                                                                              ]
                                                                                              l
                                                                                            ]
                                                                                            r
                                                                                          ]
                                                                                        )
                                                                                      )
                                                                                    ]
                                                                                    (lam
                                                                                      thunk
                                                                                      Unit
                                                                                      [
                                                                                        fail
                                                                                        (abs
                                                                                          e
                                                                                          (type)
                                                                                          (error
                                                                                            e
                                                                                          )
                                                                                        )
                                                                                      ]
                                                                                    )
                                                                                  ]
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    [
                                                                                      fail
                                                                                      (abs
                                                                                        e
                                                                                        (type)
                                                                                        (error
                                                                                          e
                                                                                        )
                                                                                      )
                                                                                    ]
                                                                                  )
                                                                                ]
                                                                                Unit
                                                                              ]
                                                                            )
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          [
                                                                            fail
                                                                            (abs
                                                                              e
                                                                              (type)
                                                                              (error
                                                                                e
                                                                              )
                                                                            )
                                                                          ]
                                                                        )
                                                                      ]
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        GT
                                                                      )
                                                                    ]
                                                                    Unit
                                                                  ]
                                                                )
                                                              )
                                                            ]
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                [
                                                                  [
                                                                    [
                                                                      {
                                                                        [
                                                                          {
                                                                            Extended_match
                                                                            a
                                                                          }
                                                                          ds
                                                                        ]
                                                                        (fun Unit Ordering)
                                                                      }
                                                                      (lam
                                                                        l
                                                                        a
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          [
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    [
                                                                                      {
                                                                                        Extended_match
                                                                                        a
                                                                                      }
                                                                                      ds
                                                                                    ]
                                                                                    (fun Unit Ordering)
                                                                                  }
                                                                                  (lam
                                                                                    r
                                                                                    a
                                                                                    (lam
                                                                                      thunk
                                                                                      Unit
                                                                                      [
                                                                                        [
                                                                                          [
                                                                                            {
                                                                                              compare
                                                                                              a
                                                                                            }
                                                                                            dOrd
                                                                                          ]
                                                                                          l
                                                                                        ]
                                                                                        r
                                                                                      ]
                                                                                    )
                                                                                  )
                                                                                ]
                                                                                (lam
                                                                                  thunk
                                                                                  Unit
                                                                                  [
                                                                                    fail
                                                                                    (abs
                                                                                      e
                                                                                      (type)
                                                                                      (error
                                                                                        e
                                                                                      )
                                                                                    )
                                                                                  ]
                                                                                )
                                                                              ]
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                [
                                                                                  fail
                                                                                  (abs
                                                                                    e
                                                                                    (type)
                                                                                    (error
                                                                                      e
                                                                                    )
                                                                                  )
                                                                                ]
                                                                              )
                                                                            ]
                                                                            Unit
                                                                          ]
                                                                        )
                                                                      )
                                                                    ]
                                                                    (lam
                                                                      thunk
                                                                      Unit
                                                                      [
                                                                        fail
                                                                        (abs
                                                                          e
                                                                          (type)
                                                                          (error
                                                                            e
                                                                          )
                                                                        )
                                                                      ]
                                                                    )
                                                                  ]
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    GT
                                                                  )
                                                                ]
                                                                Unit
                                                              ]
                                                            )
                                                          ]
                                                          (lam thunk Unit LT)
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  )
                                                  [
                                                    [
                                                      [
                                                        [
                                                          {
                                                            [
                                                              {
                                                                Extended_match a
                                                              }
                                                              ds
                                                            ]
                                                            (fun Unit Ordering)
                                                          }
                                                          (lam
                                                            default_arg0
                                                            a
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                fail
                                                                (abs
                                                                  e
                                                                  (type)
                                                                  (error e)
                                                                )
                                                              ]
                                                            )
                                                          )
                                                        ]
                                                        (lam
                                                          thunk
                                                          Unit
                                                          [
                                                            fail
                                                            (abs
                                                              e (type) (error e)
                                                            )
                                                          ]
                                                        )
                                                      ]
                                                      (lam
                                                        thunk
                                                        Unit
                                                        [
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  [
                                                                    {
                                                                      Extended_match
                                                                      a
                                                                    }
                                                                    ds
                                                                  ]
                                                                  (fun Unit Ordering)
                                                                }
                                                                (lam
                                                                  default_arg0
                                                                  a
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    [
                                                                      fail
                                                                      (abs
                                                                        e
                                                                        (type)
                                                                        (error e
                                                                        )
                                                                      )
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                [
                                                                  fail
                                                                  (abs
                                                                    e
                                                                    (type)
                                                                    (error e)
                                                                  )
                                                                ]
                                                              )
                                                            ]
                                                            (lam thunk Unit EQ)
                                                          ]
                                                          Unit
                                                        ]
                                                      )
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              )
                                            )
                                          ]
                                          (lam thunk Unit GT)
                                        ]
                                        (lam
                                          thunk
                                          Unit
                                          (let
                                            (nonrec)
                                            (termbind
                                              (strict)
                                              (vardecl
                                                fail
                                                (fun (all a (type) a) Ordering)
                                              )
                                              (lam
                                                ds
                                                (all a (type) a)
                                                [
                                                  [
                                                    [
                                                      [
                                                        {
                                                          [
                                                            { Extended_match a }
                                                            ds
                                                          ]
                                                          (fun Unit Ordering)
                                                        }
                                                        (lam
                                                          default_arg0
                                                          a
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              [
                                                                [
                                                                  [
                                                                    {
                                                                      [
                                                                        {
                                                                          Extended_match
                                                                          a
                                                                        }
                                                                        ds
                                                                      ]
                                                                      (fun Unit Ordering)
                                                                    }
                                                                    (lam
                                                                      l
                                                                      a
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        [
                                                                          [
                                                                            [
                                                                              [
                                                                                {
                                                                                  [
                                                                                    {
                                                                                      Extended_match
                                                                                      a
                                                                                    }
                                                                                    ds
                                                                                  ]
                                                                                  (fun Unit Ordering)
                                                                                }
                                                                                (lam
                                                                                  r
                                                                                  a
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    [
                                                                                      [
                                                                                        [
                                                                                          {
                                                                                            compare
                                                                                            a
                                                                                          }
                                                                                          dOrd
                                                                                        ]
                                                                                        l
                                                                                      ]
                                                                                      r
                                                                                    ]
                                                                                  )
                                                                                )
                                                                              ]
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                [
                                                                                  fail
                                                                                  (abs
                                                                                    e
                                                                                    (type)
                                                                                    (error
                                                                                      e
                                                                                    )
                                                                                  )
                                                                                ]
                                                                              )
                                                                            ]
                                                                            (lam
                                                                              thunk
                                                                              Unit
                                                                              [
                                                                                fail
                                                                                (abs
                                                                                  e
                                                                                  (type)
                                                                                  (error
                                                                                    e
                                                                                  )
                                                                                )
                                                                              ]
                                                                            )
                                                                          ]
                                                                          Unit
                                                                        ]
                                                                      )
                                                                    )
                                                                  ]
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    [
                                                                      fail
                                                                      (abs
                                                                        e
                                                                        (type)
                                                                        (error e
                                                                        )
                                                                      )
                                                                    ]
                                                                  )
                                                                ]
                                                                (lam
                                                                  thunk Unit GT
                                                                )
                                                              ]
                                                              Unit
                                                            ]
                                                          )
                                                        )
                                                      ]
                                                      (lam
                                                        thunk
                                                        Unit
                                                        [
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  [
                                                                    {
                                                                      Extended_match
                                                                      a
                                                                    }
                                                                    ds
                                                                  ]
                                                                  (fun Unit Ordering)
                                                                }
                                                                (lam
                                                                  l
                                                                  a
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    [
                                                                      [
                                                                        [
                                                                          [
                                                                            {
                                                                              [
                                                                                {
                                                                                  Extended_match
                                                                                  a
                                                                                }
                                                                                ds
                                                                              ]
                                                                              (fun Unit Ordering)
                                                                            }
                                                                            (lam
                                                                              r
                                                                              a
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                [
                                                                                  [
                                                                                    [
                                                                                      {
                                                                                        compare
                                                                                        a
                                                                                      }
                                                                                      dOrd
                                                                                    ]
                                                                                    l
                                                                                  ]
                                                                                  r
                                                                                ]
                                                                              )
                                                                            )
                                                                          ]
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            [
                                                                              fail
                                                                              (abs
                                                                                e
                                                                                (type)
                                                                                (error
                                                                                  e
                                                                                )
                                                                              )
                                                                            ]
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          [
                                                                            fail
                                                                            (abs
                                                                              e
                                                                              (type)
                                                                              (error
                                                                                e
                                                                              )
                                                                            )
                                                                          ]
                                                                        )
                                                                      ]
                                                                      Unit
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                [
                                                                  fail
                                                                  (abs
                                                                    e
                                                                    (type)
                                                                    (error e)
                                                                  )
                                                                ]
                                                              )
                                                            ]
                                                            (lam thunk Unit GT)
                                                          ]
                                                          Unit
                                                        ]
                                                      )
                                                    ]
                                                    (lam thunk Unit LT)
                                                  ]
                                                  Unit
                                                ]
                                              )
                                            )
                                            [
                                              [
                                                [
                                                  [
                                                    {
                                                      [
                                                        { Extended_match a } ds
                                                      ]
                                                      (fun Unit Ordering)
                                                    }
                                                    (lam
                                                      default_arg0
                                                      a
                                                      (lam
                                                        thunk
                                                        Unit
                                                        [
                                                          fail
                                                          (abs
                                                            e (type) (error e)
                                                          )
                                                        ]
                                                      )
                                                    )
                                                  ]
                                                  (lam
                                                    thunk
                                                    Unit
                                                    [
                                                      fail
                                                      (abs e (type) (error e))
                                                    ]
                                                  )
                                                ]
                                                (lam
                                                  thunk
                                                  Unit
                                                  [
                                                    [
                                                      [
                                                        [
                                                          {
                                                            [
                                                              {
                                                                Extended_match a
                                                              }
                                                              ds
                                                            ]
                                                            (fun Unit Ordering)
                                                          }
                                                          (lam
                                                            default_arg0
                                                            a
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                fail
                                                                (abs
                                                                  e
                                                                  (type)
                                                                  (error e)
                                                                )
                                                              ]
                                                            )
                                                          )
                                                        ]
                                                        (lam
                                                          thunk
                                                          Unit
                                                          [
                                                            fail
                                                            (abs
                                                              e (type) (error e)
                                                            )
                                                          ]
                                                        )
                                                      ]
                                                      (lam thunk Unit EQ)
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              ]
                                              Unit
                                            ]
                                          )
                                        )
                                      ]
                                      Unit
                                    ]
                                  )
                                ]
                                Unit
                              ]
                            )
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      fOrdUpperBound0_c
                      (all a (type) (fun [Ord a] (fun [UpperBound a] (fun [UpperBound a] Bool))))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        dOrd
                        [Ord a]
                        (lam
                          x
                          [UpperBound a]
                          (lam
                            y
                            [UpperBound a]
                            [
                              { [ { UpperBound_match a } x ] Bool }
                              (lam
                                v
                                [Extended a]
                                (lam
                                  in
                                  Bool
                                  [
                                    { [ { UpperBound_match a } y ] Bool }
                                    (lam
                                      v
                                      [Extended a]
                                      (lam
                                        in
                                        Bool
                                        [
                                          [
                                            [
                                              [
                                                {
                                                  [
                                                    Ordering_match
                                                    [
                                                      [
                                                        [
                                                          { hull_ccompare a }
                                                          dOrd
                                                        ]
                                                        v
                                                      ]
                                                      v
                                                    ]
                                                  ]
                                                  (fun Unit Bool)
                                                }
                                                (lam
                                                  thunk
                                                  Unit
                                                  [
                                                    [
                                                      [
                                                        {
                                                          [ Bool_match in ]
                                                          (fun Unit Bool)
                                                        }
                                                        (lam thunk Unit in)
                                                      ]
                                                      (lam thunk Unit True)
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              ]
                                              (lam thunk Unit False)
                                            ]
                                            (lam thunk Unit True)
                                          ]
                                          Unit
                                        ]
                                      )
                                    )
                                  ]
                                )
                              )
                            ]
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      contains
                      (all a (type) (fun [Ord a] (fun [Interval a] (fun [Interval a] Bool))))
                    )
                    (abs
                      a
                      (type)
                      (lam
                        dOrd
                        [Ord a]
                        (lam
                          ds
                          [Interval a]
                          (lam
                            ds
                            [Interval a]
                            [
                              { [ { Interval_match a } ds ] Bool }
                              (lam
                                l
                                [LowerBound a]
                                (lam
                                  h
                                  [UpperBound a]
                                  [
                                    { [ { Interval_match a } ds ] Bool }
                                    (lam
                                      l
                                      [LowerBound a]
                                      (lam
                                        h
                                        [UpperBound a]
                                        [
                                          { [ { LowerBound_match a } l ] Bool }
                                          (lam
                                            v
                                            [Extended a]
                                            (lam
                                              in
                                              Bool
                                              [
                                                {
                                                  [ { LowerBound_match a } l ]
                                                  Bool
                                                }
                                                (lam
                                                  v
                                                  [Extended a]
                                                  (lam
                                                    in
                                                    Bool
                                                    [
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                Ordering_match
                                                                [
                                                                  [
                                                                    [
                                                                      {
                                                                        hull_ccompare
                                                                        a
                                                                      }
                                                                      dOrd
                                                                    ]
                                                                    v
                                                                  ]
                                                                  v
                                                                ]
                                                              ]
                                                              (fun Unit Bool)
                                                            }
                                                            (lam
                                                              thunk
                                                              Unit
                                                              [
                                                                [
                                                                  [
                                                                    {
                                                                      [
                                                                        Bool_match
                                                                        in
                                                                      ]
                                                                      (fun Unit Bool)
                                                                    }
                                                                    (lam
                                                                      thunk
                                                                      Unit
                                                                      [
                                                                        [
                                                                          [
                                                                            {
                                                                              [
                                                                                Bool_match
                                                                                in
                                                                              ]
                                                                              (fun Unit Bool)
                                                                            }
                                                                            (lam
                                                                              thunk
                                                                              Unit
                                                                              [
                                                                                [
                                                                                  [
                                                                                    {
                                                                                      fOrdUpperBound0_c
                                                                                      a
                                                                                    }
                                                                                    dOrd
                                                                                  ]
                                                                                  h
                                                                                ]
                                                                                h
                                                                              ]
                                                                            )
                                                                          ]
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            False
                                                                          )
                                                                        ]
                                                                        Unit
                                                                      ]
                                                                    )
                                                                  ]
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    [
                                                                      [
                                                                        [
                                                                          {
                                                                            fOrdUpperBound0_c
                                                                            a
                                                                          }
                                                                          dOrd
                                                                        ]
                                                                        h
                                                                      ]
                                                                      h
                                                                    ]
                                                                  )
                                                                ]
                                                                Unit
                                                              ]
                                                            )
                                                          ]
                                                          (lam thunk Unit False)
                                                        ]
                                                        (lam
                                                          thunk
                                                          Unit
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  fOrdUpperBound0_c
                                                                  a
                                                                }
                                                                dOrd
                                                              ]
                                                              h
                                                            ]
                                                            h
                                                          ]
                                                        )
                                                      ]
                                                      Unit
                                                    ]
                                                  )
                                                )
                                              ]
                                            )
                                          )
                                        ]
                                      )
                                    )
                                  ]
                                )
                              )
                            ]
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl equalsData (fun (con data) (fun (con data) Bool)))
                    (lam
                      d
                      (con data)
                      (lam
                        d
                        (con data)
                        [
                          [
                            [
                              { (builtin ifThenElse) Bool }
                              [ [ (builtin equalsData) d ] d ]
                            ]
                            True
                          ]
                          False
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      findDatum
                      (fun (con bytestring) (fun TxInfo [Maybe (con data)]))
                    )
                    (lam
                      dsh
                      (con bytestring)
                      (lam
                        ds
                        TxInfo
                        [
                          { [ TxInfo_match ds ] [Maybe (con data)] }
                          (lam
                            ds
                            [List TxInInfo]
                            (lam
                              ds
                              [List TxOut]
                              (lam
                                ds
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                (lam
                                  ds
                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                  (lam
                                    ds
                                    [List DCert]
                                    (lam
                                      ds
                                      [List [[Tuple2 StakingCredential] (con integer)]]
                                      (lam
                                        ds
                                        [Interval (con integer)]
                                        (lam
                                          ds
                                          [List (con bytestring)]
                                          (lam
                                            ds
                                            [List [[Tuple2 (con bytestring)] (con data)]]
                                            (lam
                                              ds
                                              (con bytestring)
                                              [
                                                [
                                                  [
                                                    {
                                                      [
                                                        {
                                                          Maybe_match
                                                          [[Tuple2 (con bytestring)] (con data)]
                                                        }
                                                        [
                                                          [
                                                            [
                                                              {
                                                                {
                                                                  fFoldableNil_cfoldMap
                                                                  [(lam a (type) [Maybe a]) [[Tuple2 (con bytestring)] (con data)]]
                                                                }
                                                                [[Tuple2 (con bytestring)] (con data)]
                                                              }
                                                              {
                                                                fMonoidFirst
                                                                [[Tuple2 (con bytestring)] (con data)]
                                                              }
                                                            ]
                                                            (lam
                                                              x
                                                              [[Tuple2 (con bytestring)] (con data)]
                                                              [
                                                                {
                                                                  [
                                                                    {
                                                                      {
                                                                        Tuple2_match
                                                                        (con bytestring)
                                                                      }
                                                                      (con data)
                                                                    }
                                                                    x
                                                                  ]
                                                                  [Maybe [[Tuple2 (con bytestring)] (con data)]]
                                                                }
                                                                (lam
                                                                  dsh
                                                                  (con bytestring)
                                                                  (lam
                                                                    ds
                                                                    (con data)
                                                                    [
                                                                      [
                                                                        [
                                                                          {
                                                                            [
                                                                              Bool_match
                                                                              [
                                                                                [
                                                                                  [
                                                                                    {
                                                                                      (builtin
                                                                                        ifThenElse
                                                                                      )
                                                                                      Bool
                                                                                    }
                                                                                    [
                                                                                      [
                                                                                        (builtin
                                                                                          equalsByteString
                                                                                        )
                                                                                        dsh
                                                                                      ]
                                                                                      dsh
                                                                                    ]
                                                                                  ]
                                                                                  True
                                                                                ]
                                                                                False
                                                                              ]
                                                                            ]
                                                                            (fun Unit [Maybe [[Tuple2 (con bytestring)] (con data)]])
                                                                          }
                                                                          (lam
                                                                            thunk
                                                                            Unit
                                                                            [
                                                                              {
                                                                                Just
                                                                                [[Tuple2 (con bytestring)] (con data)]
                                                                              }
                                                                              x
                                                                            ]
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          {
                                                                            Nothing
                                                                            [[Tuple2 (con bytestring)] (con data)]
                                                                          }
                                                                        )
                                                                      ]
                                                                      Unit
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                            )
                                                          ]
                                                          ds
                                                        ]
                                                      ]
                                                      (fun Unit [Maybe (con data)])
                                                    }
                                                    (lam
                                                      a
                                                      [[Tuple2 (con bytestring)] (con data)]
                                                      (lam
                                                        thunk
                                                        Unit
                                                        [
                                                          { Just (con data) }
                                                          [
                                                            {
                                                              [
                                                                {
                                                                  {
                                                                    Tuple2_match
                                                                    (con bytestring)
                                                                  }
                                                                  (con data)
                                                                }
                                                                a
                                                              ]
                                                              (con data)
                                                            }
                                                            (lam
                                                              ds
                                                              (con bytestring)
                                                              (lam
                                                                b (con data) b
                                                              )
                                                            )
                                                          ]
                                                        ]
                                                      )
                                                    )
                                                  ]
                                                  (lam
                                                    thunk
                                                    Unit
                                                    { Nothing (con data) }
                                                  )
                                                ]
                                                Unit
                                              ]
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      findTxInByTxOutRef
                      (fun TxOutRef (fun TxInfo [Maybe TxInInfo]))
                    )
                    (lam
                      outRef
                      TxOutRef
                      (lam
                        ds
                        TxInfo
                        [
                          { [ TxInfo_match ds ] [Maybe TxInInfo] }
                          (lam
                            ds
                            [List TxInInfo]
                            (lam
                              ds
                              [List TxOut]
                              (lam
                                ds
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                (lam
                                  ds
                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                  (lam
                                    ds
                                    [List DCert]
                                    (lam
                                      ds
                                      [List [[Tuple2 StakingCredential] (con integer)]]
                                      (lam
                                        ds
                                        [Interval (con integer)]
                                        (lam
                                          ds
                                          [List (con bytestring)]
                                          (lam
                                            ds
                                            [List [[Tuple2 (con bytestring)] (con data)]]
                                            (lam
                                              ds
                                              (con bytestring)
                                              [
                                                [
                                                  [
                                                    {
                                                      {
                                                        fFoldableNil_cfoldMap
                                                        [(lam a (type) [Maybe a]) TxInInfo]
                                                      }
                                                      TxInInfo
                                                    }
                                                    { fMonoidFirst TxInInfo }
                                                  ]
                                                  (lam
                                                    x
                                                    TxInInfo
                                                    [
                                                      {
                                                        [ TxInInfo_match x ]
                                                        [Maybe TxInInfo]
                                                      }
                                                      (lam
                                                        ds
                                                        TxOutRef
                                                        (lam
                                                          ds
                                                          TxOut
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  [
                                                                    Bool_match
                                                                    [
                                                                      [
                                                                        fEqTxOutRef_c
                                                                        ds
                                                                      ]
                                                                      outRef
                                                                    ]
                                                                  ]
                                                                  (fun Unit [Maybe TxInInfo])
                                                                }
                                                                (lam
                                                                  thunk
                                                                  Unit
                                                                  [
                                                                    {
                                                                      Just
                                                                      TxInInfo
                                                                    }
                                                                    x
                                                                  ]
                                                                )
                                                              ]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                {
                                                                  Nothing
                                                                  TxInInfo
                                                                }
                                                              )
                                                            ]
                                                            Unit
                                                          ]
                                                        )
                                                      )
                                                    ]
                                                  )
                                                ]
                                                ds
                                              ]
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      snd (all a (type) (all b (type) (fun [[Tuple2 a] b] b)))
                    )
                    (abs
                      a
                      (type)
                      (abs
                        b
                        (type)
                        (lam
                          ds
                          [[Tuple2 a] b]
                          [
                            { [ { { Tuple2_match a } b } ds ] b }
                            (lam ds a (lam b b b))
                          ]
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl txSignedBy (fun TxInfo (fun (con bytestring) Bool))
                    )
                    (lam
                      ds
                      TxInfo
                      (lam
                        k
                        (con bytestring)
                        [
                          { [ TxInfo_match ds ] Bool }
                          (lam
                            ds
                            [List TxInInfo]
                            (lam
                              ds
                              [List TxOut]
                              (lam
                                ds
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                (lam
                                  ds
                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                  (lam
                                    ds
                                    [List DCert]
                                    (lam
                                      ds
                                      [List [[Tuple2 StakingCredential] (con integer)]]
                                      (lam
                                        ds
                                        [Interval (con integer)]
                                        (lam
                                          ds
                                          [List (con bytestring)]
                                          (lam
                                            ds
                                            [List [[Tuple2 (con bytestring)] (con data)]]
                                            (lam
                                              ds
                                              (con bytestring)
                                              [
                                                [
                                                  [
                                                    {
                                                      [
                                                        {
                                                          Maybe_match
                                                          (con bytestring)
                                                        }
                                                        [
                                                          [
                                                            [
                                                              {
                                                                {
                                                                  fFoldableNil_cfoldMap
                                                                  [(lam a (type) [Maybe a]) (con bytestring)]
                                                                }
                                                                (con bytestring)
                                                              }
                                                              {
                                                                fMonoidFirst
                                                                (con bytestring)
                                                              }
                                                            ]
                                                            (lam
                                                              x
                                                              (con bytestring)
                                                              [
                                                                [
                                                                  [
                                                                    {
                                                                      [
                                                                        Bool_match
                                                                        [
                                                                          [
                                                                            [
                                                                              {
                                                                                (builtin
                                                                                  ifThenElse
                                                                                )
                                                                                Bool
                                                                              }
                                                                              [
                                                                                [
                                                                                  (builtin
                                                                                    equalsByteString
                                                                                  )
                                                                                  k
                                                                                ]
                                                                                x
                                                                              ]
                                                                            ]
                                                                            True
                                                                          ]
                                                                          False
                                                                        ]
                                                                      ]
                                                                      (fun Unit [Maybe (con bytestring)])
                                                                    }
                                                                    (lam
                                                                      thunk
                                                                      Unit
                                                                      [
                                                                        {
                                                                          Just
                                                                          (con bytestring)
                                                                        }
                                                                        x
                                                                      ]
                                                                    )
                                                                  ]
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    {
                                                                      Nothing
                                                                      (con bytestring)
                                                                    }
                                                                  )
                                                                ]
                                                                Unit
                                                              ]
                                                            )
                                                          ]
                                                          ds
                                                        ]
                                                      ]
                                                      (fun Unit Bool)
                                                    }
                                                    (lam
                                                      ds
                                                      (con bytestring)
                                                      (lam thunk Unit True)
                                                    )
                                                  ]
                                                  (lam thunk Unit False)
                                                ]
                                                Unit
                                              ]
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      valueOf
                      (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun (con bytestring) (fun (con bytestring) (con integer))))
                    )
                    (lam
                      ds
                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                      (lam
                        cur
                        (con bytestring)
                        (lam
                          tn
                          (con bytestring)
                          (let
                            (nonrec)
                            (termbind
                              (strict)
                              (vardecl
                                j
                                (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)] (con integer))
                              )
                              (lam
                                i
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                (let
                                  (rec)
                                  (termbind
                                    (strict)
                                    (vardecl
                                      go
                                      (fun [List [[Tuple2 (con bytestring)] (con integer)]] (con integer))
                                    )
                                    (lam
                                      ds
                                      [List [[Tuple2 (con bytestring)] (con integer)]]
                                      [
                                        [
                                          {
                                            [
                                              {
                                                Nil_match
                                                [[Tuple2 (con bytestring)] (con integer)]
                                              }
                                              ds
                                            ]
                                            (con integer)
                                          }
                                          (con integer 0)
                                        ]
                                        (lam
                                          ds
                                          [[Tuple2 (con bytestring)] (con integer)]
                                          (lam
                                            xs
                                            [List [[Tuple2 (con bytestring)] (con integer)]]
                                            [
                                              {
                                                [
                                                  {
                                                    {
                                                      Tuple2_match
                                                      (con bytestring)
                                                    }
                                                    (con integer)
                                                  }
                                                  ds
                                                ]
                                                (con integer)
                                              }
                                              (lam
                                                c
                                                (con bytestring)
                                                (lam
                                                  i
                                                  (con integer)
                                                  [
                                                    [
                                                      [
                                                        {
                                                          [
                                                            Bool_match
                                                            [
                                                              [
                                                                [
                                                                  {
                                                                    (builtin
                                                                      ifThenElse
                                                                    )
                                                                    Bool
                                                                  }
                                                                  [
                                                                    [
                                                                      (builtin
                                                                        equalsByteString
                                                                      )
                                                                      c
                                                                    ]
                                                                    tn
                                                                  ]
                                                                ]
                                                                True
                                                              ]
                                                              False
                                                            ]
                                                          ]
                                                          (fun Unit (con integer))
                                                        }
                                                        (lam thunk Unit i)
                                                      ]
                                                      (lam thunk Unit [ go xs ])
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              )
                                            ]
                                          )
                                        )
                                      ]
                                    )
                                  )
                                  [ go i ]
                                )
                              )
                            )
                            (let
                              (rec)
                              (termbind
                                (strict)
                                (vardecl
                                  go
                                  (fun [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]] (con integer))
                                )
                                (lam
                                  ds
                                  [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                  [
                                    [
                                      {
                                        [
                                          {
                                            Nil_match
                                            [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                          }
                                          ds
                                        ]
                                        (con integer)
                                      }
                                      (con integer 0)
                                    ]
                                    (lam
                                      ds
                                      [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                      (lam
                                        xs
                                        [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                        [
                                          {
                                            [
                                              {
                                                {
                                                  Tuple2_match (con bytestring)
                                                }
                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                              }
                                              ds
                                            ]
                                            (con integer)
                                          }
                                          (lam
                                            c
                                            (con bytestring)
                                            (lam
                                              i
                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                              [
                                                [
                                                  [
                                                    {
                                                      [
                                                        Bool_match
                                                        [
                                                          [
                                                            [
                                                              {
                                                                (builtin
                                                                  ifThenElse
                                                                )
                                                                Bool
                                                              }
                                                              [
                                                                [
                                                                  (builtin
                                                                    equalsByteString
                                                                  )
                                                                  c
                                                                ]
                                                                cur
                                                              ]
                                                            ]
                                                            True
                                                          ]
                                                          False
                                                        ]
                                                      ]
                                                      (fun Unit (con integer))
                                                    }
                                                    (lam thunk Unit [ j i ])
                                                  ]
                                                  (lam thunk Unit [ go xs ])
                                                ]
                                                Unit
                                              ]
                                            )
                                          )
                                        ]
                                      )
                                    )
                                  ]
                                )
                              )
                              [ go ds ]
                            )
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      foldr
                      (all a (type) (all b (type) (fun (fun a (fun b b)) (fun b (fun [List a] b)))))
                    )
                    (abs
                      a
                      (type)
                      (abs
                        b
                        (type)
                        (lam
                          k
                          (fun a (fun b b))
                          (lam
                            z
                            b
                            (let
                              (rec)
                              (termbind
                                (strict)
                                (vardecl go (fun [List a] b))
                                (lam
                                  ds
                                  [List a]
                                  [
                                    [
                                      [
                                        { [ { Nil_match a } ds ] (fun Unit b) }
                                        (lam thunk Unit z)
                                      ]
                                      (lam
                                        y
                                        a
                                        (lam
                                          ys
                                          [List a]
                                          (lam thunk Unit [ [ k y ] [ go ys ] ])
                                        )
                                      )
                                    ]
                                    Unit
                                  ]
                                )
                              )
                              go
                            )
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      pubKeyOutputsAt
                      (fun (con bytestring) (fun TxInfo [List [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]))
                    )
                    (lam
                      pk
                      (con bytestring)
                      (lam
                        p
                        TxInfo
                        [
                          {
                            [ TxInfo_match p ]
                            [List [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                          }
                          (lam
                            ds
                            [List TxInInfo]
                            (lam
                              ds
                              [List TxOut]
                              (lam
                                ds
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                (lam
                                  ds
                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                  (lam
                                    ds
                                    [List DCert]
                                    (lam
                                      ds
                                      [List [[Tuple2 StakingCredential] (con integer)]]
                                      (lam
                                        ds
                                        [Interval (con integer)]
                                        (lam
                                          ds
                                          [List (con bytestring)]
                                          (lam
                                            ds
                                            [List [[Tuple2 (con bytestring)] (con data)]]
                                            (lam
                                              ds
                                              (con bytestring)
                                              [
                                                [
                                                  [
                                                    {
                                                      { foldr TxOut }
                                                      [List [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                                    }
                                                    (lam
                                                      e
                                                      TxOut
                                                      (lam
                                                        xs
                                                        [List [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                                        [
                                                          {
                                                            [ TxOut_match e ]
                                                            [List [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                                          }
                                                          (lam
                                                            ds
                                                            Address
                                                            (lam
                                                              ds
                                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                              (lam
                                                                ds
                                                                [Maybe (con bytestring)]
                                                                [
                                                                  {
                                                                    [
                                                                      Address_match
                                                                      ds
                                                                    ]
                                                                    [List [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                                                  }
                                                                  (lam
                                                                    ds
                                                                    Credential
                                                                    (lam
                                                                      ds
                                                                      [Maybe StakingCredential]
                                                                      [
                                                                        [
                                                                          {
                                                                            [
                                                                              Credential_match
                                                                              ds
                                                                            ]
                                                                            [List [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                                                          }
                                                                          (lam
                                                                            pk
                                                                            (con bytestring)
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    [
                                                                                      Bool_match
                                                                                      [
                                                                                        [
                                                                                          [
                                                                                            {
                                                                                              (builtin
                                                                                                ifThenElse
                                                                                              )
                                                                                              Bool
                                                                                            }
                                                                                            [
                                                                                              [
                                                                                                (builtin
                                                                                                  equalsByteString
                                                                                                )
                                                                                                pk
                                                                                              ]
                                                                                              pk
                                                                                            ]
                                                                                          ]
                                                                                          True
                                                                                        ]
                                                                                        False
                                                                                      ]
                                                                                    ]
                                                                                    (fun Unit [List [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]])
                                                                                  }
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    [
                                                                                      [
                                                                                        {
                                                                                          Cons
                                                                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                        }
                                                                                        ds
                                                                                      ]
                                                                                      xs
                                                                                    ]
                                                                                  )
                                                                                ]
                                                                                (lam
                                                                                  thunk
                                                                                  Unit
                                                                                  xs
                                                                                )
                                                                              ]
                                                                              Unit
                                                                            ]
                                                                          )
                                                                        ]
                                                                        (lam
                                                                          ipv
                                                                          (con bytestring)
                                                                          xs
                                                                        )
                                                                      ]
                                                                    )
                                                                  )
                                                                ]
                                                              )
                                                            )
                                                          )
                                                        ]
                                                      )
                                                    )
                                                  ]
                                                  {
                                                    Nil
                                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                  }
                                                ]
                                                ds
                                              ]
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                  (termbind
                    (nonstrict)
                    (vardecl
                      fMonoidValue_c
                      (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]))
                    )
                    [ unionWith addInteger ]
                  )
                  (termbind
                    (strict)
                    (vardecl
                      valuePaidTo
                      (fun TxInfo (fun (con bytestring) [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]))
                    )
                    (lam
                      ptx
                      TxInfo
                      (lam
                        pkh
                        (con bytestring)
                        [
                          [
                            [
                              {
                                {
                                  foldr
                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                }
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                              }
                              fMonoidValue_c
                            ]
                            {
                              Nil
                              [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                            }
                          ]
                          [ [ pubKeyOutputsAt pkh ] ptx ]
                        ]
                      )
                    )
                  )
                  (termbind
                    (nonstrict)
                    (vardecl
                      fMonoidValue
                      [Monoid [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                    )
                    [
                      [
                        {
                          CConsMonoid
                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                        }
                        fMonoidValue_c
                      ]
                      {
                        Nil
                        [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                      }
                    ]
                  )
                  (termbind
                    (strict)
                    (vardecl
                      txOutValue
                      (fun TxOut [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]])
                    )
                    (lam
                      ds
                      TxOut
                      [
                        {
                          [ TxOut_match ds ]
                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                        }
                        (lam
                          ds
                          Address
                          (lam
                            ds
                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                            (lam ds [Maybe (con bytestring)] ds)
                          )
                        )
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      valueProduced
                      (fun TxInfo [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]])
                    )
                    (lam
                      x
                      TxInfo
                      [
                        {
                          [ TxInfo_match x ]
                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                        }
                        (lam
                          ds
                          [List TxInInfo]
                          (lam
                            ds
                            [List TxOut]
                            (lam
                              ds
                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                              (lam
                                ds
                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                (lam
                                  ds
                                  [List DCert]
                                  (lam
                                    ds
                                    [List [[Tuple2 StakingCredential] (con integer)]]
                                    (lam
                                      ds
                                      [Interval (con integer)]
                                      (lam
                                        ds
                                        [List (con bytestring)]
                                        (lam
                                          ds
                                          [List [[Tuple2 (con bytestring)] (con data)]]
                                          (lam
                                            ds
                                            (con bytestring)
                                            [
                                              [
                                                [
                                                  {
                                                    {
                                                      fFoldableNil_cfoldMap
                                                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                    }
                                                    TxOut
                                                  }
                                                  fMonoidValue
                                                ]
                                                txOutValue
                                              ]
                                              ds
                                            ]
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      checkTxConstraint
                      (fun ScriptContext (fun TxConstraint Bool))
                    )
                    (lam
                      ds
                      ScriptContext
                      [
                        { [ ScriptContext_match ds ] (fun TxConstraint Bool) }
                        (lam
                          ds
                          TxInfo
                          (lam
                            ds
                            ScriptPurpose
                            (lam
                              ds
                              TxConstraint
                              [
                                [
                                  [
                                    [
                                      [
                                        [
                                          [
                                            [
                                              [
                                                [
                                                  [
                                                    {
                                                      [ TxConstraint_match ds ]
                                                      Bool
                                                    }
                                                    (lam
                                                      pubKey
                                                      (con bytestring)
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                Bool_match
                                                                [
                                                                  [
                                                                    txSignedBy
                                                                    ds
                                                                  ]
                                                                  pubKey
                                                                ]
                                                              ]
                                                              (fun Unit Bool)
                                                            }
                                                            (lam thunk Unit True
                                                            )
                                                          ]
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              [
                                                                {
                                                                  (builtin
                                                                    chooseUnit
                                                                  )
                                                                  Bool
                                                                }
                                                                [
                                                                  (builtin trace
                                                                  )
                                                                  (con
                                                                    string
                                                                      "Missing signature"
                                                                  )
                                                                ]
                                                              ]
                                                              False
                                                            ]
                                                          )
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  ]
                                                  (lam
                                                    dvh
                                                    (con bytestring)
                                                    (lam
                                                      dv
                                                      (con data)
                                                      (let
                                                        (nonrec)
                                                        (termbind
                                                          (nonstrict)
                                                          (vardecl j Bool)
                                                          [
                                                            [
                                                              {
                                                                (builtin
                                                                  chooseUnit
                                                                )
                                                                Bool
                                                              }
                                                              [
                                                                (builtin trace)
                                                                (con
                                                                  string
                                                                    "MustHashDatum"
                                                                )
                                                              ]
                                                            ]
                                                            False
                                                          ]
                                                        )
                                                        [
                                                          [
                                                            [
                                                              {
                                                                [
                                                                  {
                                                                    Maybe_match
                                                                    (con data)
                                                                  }
                                                                  [
                                                                    [
                                                                      findDatum
                                                                      dvh
                                                                    ]
                                                                    ds
                                                                  ]
                                                                ]
                                                                (fun Unit Bool)
                                                              }
                                                              (lam
                                                                a
                                                                (con data)
                                                                (lam
                                                                  thunk
                                                                  Unit
                                                                  [
                                                                    [
                                                                      [
                                                                        {
                                                                          [
                                                                            Bool_match
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    (builtin
                                                                                      ifThenElse
                                                                                    )
                                                                                    Bool
                                                                                  }
                                                                                  [
                                                                                    [
                                                                                      (builtin
                                                                                        equalsData
                                                                                      )
                                                                                      a
                                                                                    ]
                                                                                    dv
                                                                                  ]
                                                                                ]
                                                                                True
                                                                              ]
                                                                              False
                                                                            ]
                                                                          ]
                                                                          (fun Unit Bool)
                                                                        }
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          True
                                                                        )
                                                                      ]
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        j
                                                                      )
                                                                    ]
                                                                    Unit
                                                                  ]
                                                                )
                                                              )
                                                            ]
                                                            (lam thunk Unit j)
                                                          ]
                                                          Unit
                                                        ]
                                                      )
                                                    )
                                                  )
                                                ]
                                                (lam
                                                  dv
                                                  (con data)
                                                  [
                                                    { [ TxInfo_match ds ] Bool }
                                                    (lam
                                                      ds
                                                      [List TxInInfo]
                                                      (lam
                                                        ds
                                                        [List TxOut]
                                                        (lam
                                                          ds
                                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                          (lam
                                                            ds
                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                            (lam
                                                              ds
                                                              [List DCert]
                                                              (lam
                                                                ds
                                                                [List [[Tuple2 StakingCredential] (con integer)]]
                                                                (lam
                                                                  ds
                                                                  [Interval (con integer)]
                                                                  (lam
                                                                    ds
                                                                    [List (con bytestring)]
                                                                    (lam
                                                                      ds
                                                                      [List [[Tuple2 (con bytestring)] (con data)]]
                                                                      (lam
                                                                        ds
                                                                        (con bytestring)
                                                                        [
                                                                          [
                                                                            [
                                                                              {
                                                                                [
                                                                                  Bool_match
                                                                                  [
                                                                                    [
                                                                                      [
                                                                                        {
                                                                                          {
                                                                                            fFoldableNil_cfoldMap
                                                                                            [(lam a (type) a) Bool]
                                                                                          }
                                                                                          (con data)
                                                                                        }
                                                                                        [
                                                                                          {
                                                                                            fMonoidSum
                                                                                            Bool
                                                                                          }
                                                                                          fAdditiveMonoidBool
                                                                                        ]
                                                                                      ]
                                                                                      [
                                                                                        equalsData
                                                                                        dv
                                                                                      ]
                                                                                    ]
                                                                                    [
                                                                                      [
                                                                                        {
                                                                                          {
                                                                                            fFunctorNil_cfmap
                                                                                            [[Tuple2 (con bytestring)] (con data)]
                                                                                          }
                                                                                          (con data)
                                                                                        }
                                                                                        {
                                                                                          {
                                                                                            snd
                                                                                            (con bytestring)
                                                                                          }
                                                                                          (con data)
                                                                                        }
                                                                                      ]
                                                                                      ds
                                                                                    ]
                                                                                  ]
                                                                                ]
                                                                                (fun Unit Bool)
                                                                              }
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                True
                                                                              )
                                                                            ]
                                                                            (lam
                                                                              thunk
                                                                              Unit
                                                                              [
                                                                                [
                                                                                  {
                                                                                    (builtin
                                                                                      chooseUnit
                                                                                    )
                                                                                    Bool
                                                                                  }
                                                                                  [
                                                                                    (builtin
                                                                                      trace
                                                                                    )
                                                                                    (con
                                                                                      string
                                                                                        "Missing datum"
                                                                                    )
                                                                                  ]
                                                                                ]
                                                                                False
                                                                              ]
                                                                            )
                                                                          ]
                                                                          Unit
                                                                        ]
                                                                      )
                                                                    )
                                                                  )
                                                                )
                                                              )
                                                            )
                                                          )
                                                        )
                                                      )
                                                    )
                                                  ]
                                                )
                                              ]
                                              (lam
                                                mps
                                                (con bytestring)
                                                (lam
                                                  ds
                                                  (con data)
                                                  (lam
                                                    tn
                                                    (con bytestring)
                                                    (lam
                                                      v
                                                      (con integer)
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                Bool_match
                                                                [
                                                                  [
                                                                    [
                                                                      {
                                                                        (builtin
                                                                          ifThenElse
                                                                        )
                                                                        Bool
                                                                      }
                                                                      [
                                                                        [
                                                                          (builtin
                                                                            equalsInteger
                                                                          )
                                                                          [
                                                                            [
                                                                              [
                                                                                valueOf
                                                                                [
                                                                                  {
                                                                                    [
                                                                                      TxInfo_match
                                                                                      ds
                                                                                    ]
                                                                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                  }
                                                                                  (lam
                                                                                    ds
                                                                                    [List TxInInfo]
                                                                                    (lam
                                                                                      ds
                                                                                      [List TxOut]
                                                                                      (lam
                                                                                        ds
                                                                                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                        (lam
                                                                                          ds
                                                                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                          (lam
                                                                                            ds
                                                                                            [List DCert]
                                                                                            (lam
                                                                                              ds
                                                                                              [List [[Tuple2 StakingCredential] (con integer)]]
                                                                                              (lam
                                                                                                ds
                                                                                                [Interval (con integer)]
                                                                                                (lam
                                                                                                  ds
                                                                                                  [List (con bytestring)]
                                                                                                  (lam
                                                                                                    ds
                                                                                                    [List [[Tuple2 (con bytestring)] (con data)]]
                                                                                                    (lam
                                                                                                      ds
                                                                                                      (con bytestring)
                                                                                                      ds
                                                                                                    )
                                                                                                  )
                                                                                                )
                                                                                              )
                                                                                            )
                                                                                          )
                                                                                        )
                                                                                      )
                                                                                    )
                                                                                  )
                                                                                ]
                                                                              ]
                                                                              mps
                                                                            ]
                                                                            tn
                                                                          ]
                                                                        ]
                                                                        v
                                                                      ]
                                                                    ]
                                                                    True
                                                                  ]
                                                                  False
                                                                ]
                                                              ]
                                                              (fun Unit Bool)
                                                            }
                                                            (lam thunk Unit True
                                                            )
                                                          ]
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              [
                                                                {
                                                                  (builtin
                                                                    chooseUnit
                                                                  )
                                                                  Bool
                                                                }
                                                                [
                                                                  (builtin trace
                                                                  )
                                                                  (con
                                                                    string
                                                                      "Value minted not OK"
                                                                  )
                                                                ]
                                                              ]
                                                              False
                                                            ]
                                                          )
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  )
                                                )
                                              )
                                            ]
                                            (lam
                                              vlh
                                              (con bytestring)
                                              (lam
                                                dv
                                                (con data)
                                                (lam
                                                  vl
                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                  (let
                                                    (nonrec)
                                                    (termbind
                                                      (nonstrict)
                                                      (vardecl
                                                        hsh
                                                        [Maybe (con bytestring)]
                                                      )
                                                      [
                                                        [ findDatumHash dv ] ds
                                                      ]
                                                    )
                                                    (termbind
                                                      (nonstrict)
                                                      (vardecl addr Credential)
                                                      [ ScriptCredential vlh ]
                                                    )
                                                    (termbind
                                                      (nonstrict)
                                                      (vardecl addr Address)
                                                      [
                                                        [ Address addr ]
                                                        {
                                                          Nothing
                                                          StakingCredential
                                                        }
                                                      ]
                                                    )
                                                    [
                                                      {
                                                        [ TxInfo_match ds ] Bool
                                                      }
                                                      (lam
                                                        ds
                                                        [List TxInInfo]
                                                        (lam
                                                          ds
                                                          [List TxOut]
                                                          (lam
                                                            ds
                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                            (lam
                                                              ds
                                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                              (lam
                                                                ds
                                                                [List DCert]
                                                                (lam
                                                                  ds
                                                                  [List [[Tuple2 StakingCredential] (con integer)]]
                                                                  (lam
                                                                    ds
                                                                    [Interval (con integer)]
                                                                    (lam
                                                                      ds
                                                                      [List (con bytestring)]
                                                                      (lam
                                                                        ds
                                                                        [List [[Tuple2 (con bytestring)] (con data)]]
                                                                        (lam
                                                                          ds
                                                                          (con bytestring)
                                                                          [
                                                                            [
                                                                              [
                                                                                {
                                                                                  [
                                                                                    Bool_match
                                                                                    [
                                                                                      [
                                                                                        [
                                                                                          {
                                                                                            {
                                                                                              fFoldableNil_cfoldMap
                                                                                              [(lam a (type) a) Bool]
                                                                                            }
                                                                                            TxOut
                                                                                          }
                                                                                          [
                                                                                            {
                                                                                              fMonoidSum
                                                                                              Bool
                                                                                            }
                                                                                            fAdditiveMonoidBool
                                                                                          ]
                                                                                        ]
                                                                                        (lam
                                                                                          ds
                                                                                          TxOut
                                                                                          [
                                                                                            {
                                                                                              [
                                                                                                TxOut_match
                                                                                                ds
                                                                                              ]
                                                                                              Bool
                                                                                            }
                                                                                            (lam
                                                                                              ds
                                                                                              Address
                                                                                              (lam
                                                                                                ds
                                                                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                                (lam
                                                                                                  ds
                                                                                                  [Maybe (con bytestring)]
                                                                                                  [
                                                                                                    [
                                                                                                      [
                                                                                                        {
                                                                                                          [
                                                                                                            {
                                                                                                              Maybe_match
                                                                                                              (con bytestring)
                                                                                                            }
                                                                                                            ds
                                                                                                          ]
                                                                                                          (fun Unit Bool)
                                                                                                        }
                                                                                                        (lam
                                                                                                          svh
                                                                                                          (con bytestring)
                                                                                                          (lam
                                                                                                            thunk
                                                                                                            Unit
                                                                                                            [
                                                                                                              [
                                                                                                                [
                                                                                                                  {
                                                                                                                    [
                                                                                                                      Bool_match
                                                                                                                      [
                                                                                                                        [
                                                                                                                          [
                                                                                                                            checkBinRel
                                                                                                                            equalsInteger
                                                                                                                          ]
                                                                                                                          ds
                                                                                                                        ]
                                                                                                                        vl
                                                                                                                      ]
                                                                                                                    ]
                                                                                                                    (fun Unit Bool)
                                                                                                                  }
                                                                                                                  (lam
                                                                                                                    thunk
                                                                                                                    Unit
                                                                                                                    [
                                                                                                                      [
                                                                                                                        [
                                                                                                                          {
                                                                                                                            [
                                                                                                                              {
                                                                                                                                Maybe_match
                                                                                                                                (con bytestring)
                                                                                                                              }
                                                                                                                              hsh
                                                                                                                            ]
                                                                                                                            (fun Unit Bool)
                                                                                                                          }
                                                                                                                          (lam
                                                                                                                            a
                                                                                                                            (con bytestring)
                                                                                                                            (lam
                                                                                                                              thunk
                                                                                                                              Unit
                                                                                                                              [
                                                                                                                                [
                                                                                                                                  [
                                                                                                                                    {
                                                                                                                                      [
                                                                                                                                        Bool_match
                                                                                                                                        [
                                                                                                                                          [
                                                                                                                                            [
                                                                                                                                              {
                                                                                                                                                (builtin
                                                                                                                                                  ifThenElse
                                                                                                                                                )
                                                                                                                                                Bool
                                                                                                                                              }
                                                                                                                                              [
                                                                                                                                                [
                                                                                                                                                  (builtin
                                                                                                                                                    equalsByteString
                                                                                                                                                  )
                                                                                                                                                  a
                                                                                                                                                ]
                                                                                                                                                svh
                                                                                                                                              ]
                                                                                                                                            ]
                                                                                                                                            True
                                                                                                                                          ]
                                                                                                                                          False
                                                                                                                                        ]
                                                                                                                                      ]
                                                                                                                                      (fun Unit Bool)
                                                                                                                                    }
                                                                                                                                    (lam
                                                                                                                                      thunk
                                                                                                                                      Unit
                                                                                                                                      [
                                                                                                                                        [
                                                                                                                                          fEqAddress_c
                                                                                                                                          ds
                                                                                                                                        ]
                                                                                                                                        addr
                                                                                                                                      ]
                                                                                                                                    )
                                                                                                                                  ]
                                                                                                                                  (lam
                                                                                                                                    thunk
                                                                                                                                    Unit
                                                                                                                                    False
                                                                                                                                  )
                                                                                                                                ]
                                                                                                                                Unit
                                                                                                                              ]
                                                                                                                            )
                                                                                                                          )
                                                                                                                        ]
                                                                                                                        (lam
                                                                                                                          thunk
                                                                                                                          Unit
                                                                                                                          False
                                                                                                                        )
                                                                                                                      ]
                                                                                                                      Unit
                                                                                                                    ]
                                                                                                                  )
                                                                                                                ]
                                                                                                                (lam
                                                                                                                  thunk
                                                                                                                  Unit
                                                                                                                  False
                                                                                                                )
                                                                                                              ]
                                                                                                              Unit
                                                                                                            ]
                                                                                                          )
                                                                                                        )
                                                                                                      ]
                                                                                                      (lam
                                                                                                        thunk
                                                                                                        Unit
                                                                                                        False
                                                                                                      )
                                                                                                    ]
                                                                                                    Unit
                                                                                                  ]
                                                                                                )
                                                                                              )
                                                                                            )
                                                                                          ]
                                                                                        )
                                                                                      ]
                                                                                      ds
                                                                                    ]
                                                                                  ]
                                                                                  (fun Unit Bool)
                                                                                }
                                                                                (lam
                                                                                  thunk
                                                                                  Unit
                                                                                  True
                                                                                )
                                                                              ]
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                [
                                                                                  [
                                                                                    {
                                                                                      (builtin
                                                                                        chooseUnit
                                                                                      )
                                                                                      Bool
                                                                                    }
                                                                                    [
                                                                                      (builtin
                                                                                        trace
                                                                                      )
                                                                                      (con
                                                                                        string
                                                                                          "MustPayToOtherScript"
                                                                                      )
                                                                                    ]
                                                                                  ]
                                                                                  False
                                                                                ]
                                                                              )
                                                                            ]
                                                                            Unit
                                                                          ]
                                                                        )
                                                                      )
                                                                    )
                                                                  )
                                                                )
                                                              )
                                                            )
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  )
                                                )
                                              )
                                            )
                                          ]
                                          (lam
                                            pk
                                            (con bytestring)
                                            (lam
                                              vl
                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                              [
                                                [
                                                  [
                                                    {
                                                      [
                                                        Bool_match
                                                        [
                                                          [
                                                            [
                                                              checkBinRel
                                                              lessThanEqInteger
                                                            ]
                                                            vl
                                                          ]
                                                          [
                                                            [ valuePaidTo ds ]
                                                            pk
                                                          ]
                                                        ]
                                                      ]
                                                      (fun Unit Bool)
                                                    }
                                                    (lam thunk Unit True)
                                                  ]
                                                  (lam
                                                    thunk
                                                    Unit
                                                    [
                                                      [
                                                        {
                                                          (builtin chooseUnit)
                                                          Bool
                                                        }
                                                        [
                                                          (builtin trace)
                                                          (con
                                                            string
                                                              "MustPayToPubKey"
                                                          )
                                                        ]
                                                      ]
                                                      False
                                                    ]
                                                  )
                                                ]
                                                Unit
                                              ]
                                            )
                                          )
                                        ]
                                        (lam
                                          vl
                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                          [
                                            [
                                              [
                                                {
                                                  [
                                                    Bool_match
                                                    [
                                                      [
                                                        [
                                                          checkBinRel
                                                          lessThanEqInteger
                                                        ]
                                                        vl
                                                      ]
                                                      [ valueProduced ds ]
                                                    ]
                                                  ]
                                                  (fun Unit Bool)
                                                }
                                                (lam thunk Unit True)
                                              ]
                                              (lam
                                                thunk
                                                Unit
                                                [
                                                  [
                                                    {
                                                      (builtin chooseUnit) Bool
                                                    }
                                                    [
                                                      (builtin trace)
                                                      (con
                                                        string
                                                          "Produced value not OK"
                                                      )
                                                    ]
                                                  ]
                                                  False
                                                ]
                                              )
                                            ]
                                            Unit
                                          ]
                                        )
                                      ]
                                      (lam
                                        vl
                                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                        [
                                          [
                                            [
                                              {
                                                [
                                                  Bool_match
                                                  [
                                                    [
                                                      [
                                                        checkBinRel
                                                        lessThanEqInteger
                                                      ]
                                                      vl
                                                    ]
                                                    [
                                                      {
                                                        [ TxInfo_match ds ]
                                                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                      }
                                                      (lam
                                                        ds
                                                        [List TxInInfo]
                                                        (lam
                                                          ds
                                                          [List TxOut]
                                                          (lam
                                                            ds
                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                            (lam
                                                              ds
                                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                              (lam
                                                                ds
                                                                [List DCert]
                                                                (lam
                                                                  ds
                                                                  [List [[Tuple2 StakingCredential] (con integer)]]
                                                                  (lam
                                                                    ds
                                                                    [Interval (con integer)]
                                                                    (lam
                                                                      ds
                                                                      [List (con bytestring)]
                                                                      (lam
                                                                        ds
                                                                        [List [[Tuple2 (con bytestring)] (con data)]]
                                                                        (lam
                                                                          ds
                                                                          (con bytestring)
                                                                          [
                                                                            [
                                                                              [
                                                                                {
                                                                                  {
                                                                                    fFoldableNil_cfoldMap
                                                                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                  }
                                                                                  TxInInfo
                                                                                }
                                                                                fMonoidValue
                                                                              ]
                                                                              (lam
                                                                                x
                                                                                TxInInfo
                                                                                [
                                                                                  {
                                                                                    [
                                                                                      TxInInfo_match
                                                                                      x
                                                                                    ]
                                                                                    [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                  }
                                                                                  (lam
                                                                                    ds
                                                                                    TxOutRef
                                                                                    (lam
                                                                                      ds
                                                                                      TxOut
                                                                                      [
                                                                                        {
                                                                                          [
                                                                                            TxOut_match
                                                                                            ds
                                                                                          ]
                                                                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                        }
                                                                                        (lam
                                                                                          ds
                                                                                          Address
                                                                                          (lam
                                                                                            ds
                                                                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                                            (lam
                                                                                              ds
                                                                                              [Maybe (con bytestring)]
                                                                                              ds
                                                                                            )
                                                                                          )
                                                                                        )
                                                                                      ]
                                                                                    )
                                                                                  )
                                                                                ]
                                                                              )
                                                                            ]
                                                                            ds
                                                                          ]
                                                                        )
                                                                      )
                                                                    )
                                                                  )
                                                                )
                                                              )
                                                            )
                                                          )
                                                        )
                                                      )
                                                    ]
                                                  ]
                                                ]
                                                (fun Unit Bool)
                                              }
                                              (lam thunk Unit True)
                                            ]
                                            (lam
                                              thunk
                                              Unit
                                              [
                                                [
                                                  { (builtin chooseUnit) Bool }
                                                  [
                                                    (builtin trace)
                                                    (con
                                                      string
                                                        "Spent value not OK"
                                                    )
                                                  ]
                                                ]
                                                False
                                              ]
                                            )
                                          ]
                                          Unit
                                        ]
                                      )
                                    ]
                                    (lam
                                      txOutRef
                                      TxOutRef
                                      (let
                                        (nonrec)
                                        (termbind
                                          (nonstrict)
                                          (vardecl j Bool)
                                          [
                                            [
                                              { (builtin chooseUnit) Bool }
                                              [
                                                (builtin trace)
                                                (con
                                                  string
                                                    "Public key output not spent"
                                                )
                                              ]
                                            ]
                                            False
                                          ]
                                        )
                                        [
                                          [
                                            [
                                              {
                                                [
                                                  { Maybe_match TxInInfo }
                                                  [
                                                    [
                                                      findTxInByTxOutRef
                                                      txOutRef
                                                    ]
                                                    ds
                                                  ]
                                                ]
                                                (fun Unit Bool)
                                              }
                                              (lam
                                                a
                                                TxInInfo
                                                (lam
                                                  thunk
                                                  Unit
                                                  [
                                                    {
                                                      [ TxInInfo_match a ] Bool
                                                    }
                                                    (lam
                                                      ds
                                                      TxOutRef
                                                      (lam
                                                        ds
                                                        TxOut
                                                        [
                                                          {
                                                            [ TxOut_match ds ]
                                                            Bool
                                                          }
                                                          (lam
                                                            ds
                                                            Address
                                                            (lam
                                                              ds
                                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                              (lam
                                                                ds
                                                                [Maybe (con bytestring)]
                                                                [
                                                                  [
                                                                    [
                                                                      {
                                                                        [
                                                                          {
                                                                            Maybe_match
                                                                            (con bytestring)
                                                                          }
                                                                          ds
                                                                        ]
                                                                        (fun Unit Bool)
                                                                      }
                                                                      (lam
                                                                        ds
                                                                        (con bytestring)
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          j
                                                                        )
                                                                      )
                                                                    ]
                                                                    (lam
                                                                      thunk
                                                                      Unit
                                                                      True
                                                                    )
                                                                  ]
                                                                  Unit
                                                                ]
                                                              )
                                                            )
                                                          )
                                                        ]
                                                      )
                                                    )
                                                  ]
                                                )
                                              )
                                            ]
                                            (lam thunk Unit j)
                                          ]
                                          Unit
                                        ]
                                      )
                                    )
                                  ]
                                  (lam
                                    txOutRef
                                    TxOutRef
                                    (lam
                                      ds
                                      (con data)
                                      [
                                        [
                                          [
                                            {
                                              [
                                                { Maybe_match TxInInfo }
                                                [
                                                  [
                                                    findTxInByTxOutRef txOutRef
                                                  ]
                                                  ds
                                                ]
                                              ]
                                              (fun Unit Bool)
                                            }
                                            (lam
                                              ds TxInInfo (lam thunk Unit True)
                                            )
                                          ]
                                          (lam
                                            thunk
                                            Unit
                                            [
                                              [
                                                { (builtin chooseUnit) Bool }
                                                [
                                                  (builtin trace)
                                                  (con
                                                    string
                                                      "Script output not spent"
                                                  )
                                                ]
                                              ]
                                              False
                                            ]
                                          )
                                        ]
                                        Unit
                                      ]
                                    )
                                  )
                                ]
                                (lam
                                  interval
                                  [Interval (con integer)]
                                  [
                                    [
                                      [
                                        {
                                          [
                                            Bool_match
                                            [
                                              [
                                                [
                                                  { contains (con integer) }
                                                  fOrdPOSIXTime
                                                ]
                                                interval
                                              ]
                                              [
                                                {
                                                  [ TxInfo_match ds ]
                                                  [Interval (con integer)]
                                                }
                                                (lam
                                                  ds
                                                  [List TxInInfo]
                                                  (lam
                                                    ds
                                                    [List TxOut]
                                                    (lam
                                                      ds
                                                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                      (lam
                                                        ds
                                                        [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                        (lam
                                                          ds
                                                          [List DCert]
                                                          (lam
                                                            ds
                                                            [List [[Tuple2 StakingCredential] (con integer)]]
                                                            (lam
                                                              ds
                                                              [Interval (con integer)]
                                                              (lam
                                                                ds
                                                                [List (con bytestring)]
                                                                (lam
                                                                  ds
                                                                  [List [[Tuple2 (con bytestring)] (con data)]]
                                                                  (lam
                                                                    ds
                                                                    (con bytestring)
                                                                    ds
                                                                  )
                                                                )
                                                              )
                                                            )
                                                          )
                                                        )
                                                      )
                                                    )
                                                  )
                                                )
                                              ]
                                            ]
                                          ]
                                          (fun Unit Bool)
                                        }
                                        (lam thunk Unit True)
                                      ]
                                      (lam
                                        thunk
                                        Unit
                                        [
                                          [
                                            { (builtin chooseUnit) Bool }
                                            [
                                              (builtin trace)
                                              (con
                                                string
                                                  "Wrong validation interval"
                                              )
                                            ]
                                          ]
                                          False
                                        ]
                                      )
                                    ]
                                    Unit
                                  ]
                                )
                              ]
                            )
                          )
                        )
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      checkScriptContext
                      (all i (type) (all o (type) (fun [(lam a (type) (fun a (con data))) o] (fun [[TxConstraints i] o] (fun ScriptContext Bool)))))
                    )
                    (abs
                      i
                      (type)
                      (abs
                        o
                        (type)
                        (lam
                          dToData
                          [(lam a (type) (fun a (con data))) o]
                          (lam
                            ds
                            [[TxConstraints i] o]
                            (lam
                              ptx
                              ScriptContext
                              [
                                { [ { { TxConstraints_match i } o } ds ] Bool }
                                (lam
                                  ds
                                  [List TxConstraint]
                                  (lam
                                    ds
                                    [List [InputConstraint i]]
                                    (lam
                                      ds
                                      [List [OutputConstraint o]]
                                      (let
                                        (nonrec)
                                        (termbind
                                          (nonstrict)
                                          (vardecl j Bool)
                                          [
                                            [
                                              { (builtin chooseUnit) Bool }
                                              [
                                                (builtin trace)
                                                (con
                                                  string
                                                    "checkScriptContext failed"
                                                )
                                              ]
                                            ]
                                            False
                                          ]
                                        )
                                        [
                                          [
                                            [
                                              {
                                                [
                                                  Bool_match
                                                  [
                                                    [
                                                      [
                                                        {
                                                          {
                                                            fFoldableNil_cfoldMap
                                                            [(lam a (type) a) Bool]
                                                          }
                                                          TxConstraint
                                                        }
                                                        [
                                                          {
                                                            fMonoidProduct Bool
                                                          }
                                                          fMultiplicativeMonoidBool
                                                        ]
                                                      ]
                                                      [ checkTxConstraint ptx ]
                                                    ]
                                                    ds
                                                  ]
                                                ]
                                                (fun Unit Bool)
                                              }
                                              (lam
                                                thunk
                                                Unit
                                                [
                                                  [
                                                    [
                                                      {
                                                        [
                                                          Bool_match
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  {
                                                                    fFoldableNil_cfoldMap
                                                                    [(lam a (type) a) Bool]
                                                                  }
                                                                  [InputConstraint i]
                                                                }
                                                                [
                                                                  {
                                                                    fMonoidProduct
                                                                    Bool
                                                                  }
                                                                  fMultiplicativeMonoidBool
                                                                ]
                                                              ]
                                                              [
                                                                {
                                                                  checkOwnInputConstraint
                                                                  i
                                                                }
                                                                ptx
                                                              ]
                                                            ]
                                                            ds
                                                          ]
                                                        ]
                                                        (fun Unit Bool)
                                                      }
                                                      (lam
                                                        thunk
                                                        Unit
                                                        [
                                                          [
                                                            [
                                                              {
                                                                [
                                                                  Bool_match
                                                                  [
                                                                    [
                                                                      [
                                                                        {
                                                                          {
                                                                            fFoldableNil_cfoldMap
                                                                            [(lam a (type) a) Bool]
                                                                          }
                                                                          [OutputConstraint o]
                                                                        }
                                                                        [
                                                                          {
                                                                            fMonoidProduct
                                                                            Bool
                                                                          }
                                                                          fMultiplicativeMonoidBool
                                                                        ]
                                                                      ]
                                                                      [
                                                                        [
                                                                          {
                                                                            checkOwnOutputConstraint
                                                                            o
                                                                          }
                                                                          dToData
                                                                        ]
                                                                        ptx
                                                                      ]
                                                                    ]
                                                                    ds
                                                                  ]
                                                                ]
                                                                (fun Unit Bool)
                                                              }
                                                              (lam
                                                                thunk Unit True
                                                              )
                                                            ]
                                                            (lam thunk Unit j)
                                                          ]
                                                          Unit
                                                        ]
                                                      )
                                                    ]
                                                    (lam thunk Unit j)
                                                  ]
                                                  Unit
                                                ]
                                              )
                                            ]
                                            (lam thunk Unit j)
                                          ]
                                          Unit
                                        ]
                                      )
                                    )
                                  )
                                )
                              ]
                            )
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      isZero
                      (fun [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]] Bool)
                    )
                    (lam
                      ds
                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                      (let
                        (rec)
                        (termbind
                          (strict)
                          (vardecl
                            go
                            (fun [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]] Bool)
                          )
                          (lam
                            xs
                            [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                            [
                              [
                                [
                                  {
                                    [
                                      {
                                        Nil_match
                                        [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                      }
                                      xs
                                    ]
                                    (fun Unit Bool)
                                  }
                                  (lam thunk Unit True)
                                ]
                                (lam
                                  ds
                                  [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                  (lam
                                    xs
                                    [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]]
                                    (lam
                                      thunk
                                      Unit
                                      [
                                        {
                                          [
                                            {
                                              { Tuple2_match (con bytestring) }
                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                            }
                                            ds
                                          ]
                                          Bool
                                        }
                                        (lam
                                          ds
                                          (con bytestring)
                                          (lam
                                            x
                                            [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                            (let
                                              (rec)
                                              (termbind
                                                (strict)
                                                (vardecl
                                                  go
                                                  (fun [List [[Tuple2 (con bytestring)] (con integer)]] Bool)
                                                )
                                                (lam
                                                  xs
                                                  [List [[Tuple2 (con bytestring)] (con integer)]]
                                                  [
                                                    [
                                                      [
                                                        {
                                                          [
                                                            {
                                                              Nil_match
                                                              [[Tuple2 (con bytestring)] (con integer)]
                                                            }
                                                            xs
                                                          ]
                                                          (fun Unit Bool)
                                                        }
                                                        (lam
                                                          thunk Unit [ go xs ]
                                                        )
                                                      ]
                                                      (lam
                                                        ds
                                                        [[Tuple2 (con bytestring)] (con integer)]
                                                        (lam
                                                          xs
                                                          [List [[Tuple2 (con bytestring)] (con integer)]]
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              {
                                                                [
                                                                  {
                                                                    {
                                                                      Tuple2_match
                                                                      (con bytestring)
                                                                    }
                                                                    (con integer)
                                                                  }
                                                                  ds
                                                                ]
                                                                Bool
                                                              }
                                                              (lam
                                                                ds
                                                                (con bytestring)
                                                                (lam
                                                                  x
                                                                  (con integer)
                                                                  [
                                                                    [
                                                                      [
                                                                        {
                                                                          [
                                                                            Bool_match
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    (builtin
                                                                                      ifThenElse
                                                                                    )
                                                                                    Bool
                                                                                  }
                                                                                  [
                                                                                    [
                                                                                      (builtin
                                                                                        equalsInteger
                                                                                      )
                                                                                      (con
                                                                                        integer
                                                                                          0
                                                                                      )
                                                                                    ]
                                                                                    x
                                                                                  ]
                                                                                ]
                                                                                True
                                                                              ]
                                                                              False
                                                                            ]
                                                                          ]
                                                                          (fun Unit Bool)
                                                                        }
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          [
                                                                            go
                                                                            xs
                                                                          ]
                                                                        )
                                                                      ]
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        False
                                                                      )
                                                                    ]
                                                                    Unit
                                                                  ]
                                                                )
                                                              )
                                                            ]
                                                          )
                                                        )
                                                      )
                                                    ]
                                                    Unit
                                                  ]
                                                )
                                              )
                                              [ go x ]
                                            )
                                          )
                                        )
                                      ]
                                    )
                                  )
                                )
                              ]
                              Unit
                            ]
                          )
                        )
                        [ go ds ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      ownHashes
                      (fun ScriptContext [[Tuple2 (con bytestring)] (con bytestring)])
                    )
                    (lam
                      ds
                      ScriptContext
                      (let
                        (nonrec)
                        (termbind
                          (strict)
                          (vardecl
                            fail
                            (fun (all a (type) a) [[Tuple2 (con bytestring)] (con bytestring)])
                          )
                          (lam
                            ds
                            (all a (type) a)
                            [
                              {
                                error
                                [[Tuple2 (con bytestring)] (con bytestring)]
                              }
                              [
                                {
                                  [
                                    Unit_match
                                    [
                                      [
                                        { (builtin chooseUnit) Unit }
                                        [
                                          (builtin trace)
                                          (con
                                            string
                                              "Can't get validator and datum hashes"
                                          )
                                        ]
                                      ]
                                      Unit
                                    ]
                                  ]
                                  (con unit)
                                }
                                (con unit ())
                              ]
                            ]
                          )
                        )
                        [
                          [
                            [
                              {
                                [ { Maybe_match TxInInfo } [ findOwnInput ds ] ]
                                (fun Unit [[Tuple2 (con bytestring)] (con bytestring)])
                              }
                              (lam
                                ds
                                TxInInfo
                                (lam
                                  thunk
                                  Unit
                                  [
                                    {
                                      [ TxInInfo_match ds ]
                                      [[Tuple2 (con bytestring)] (con bytestring)]
                                    }
                                    (lam
                                      ds
                                      TxOutRef
                                      (lam
                                        ds
                                        TxOut
                                        [
                                          {
                                            [ TxOut_match ds ]
                                            [[Tuple2 (con bytestring)] (con bytestring)]
                                          }
                                          (lam
                                            ds
                                            Address
                                            (lam
                                              ds
                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                              (lam
                                                ds
                                                [Maybe (con bytestring)]
                                                [
                                                  {
                                                    [ Address_match ds ]
                                                    [[Tuple2 (con bytestring)] (con bytestring)]
                                                  }
                                                  (lam
                                                    ds
                                                    Credential
                                                    (lam
                                                      ds
                                                      [Maybe StakingCredential]
                                                      [
                                                        [
                                                          {
                                                            [
                                                              Credential_match
                                                              ds
                                                            ]
                                                            [[Tuple2 (con bytestring)] (con bytestring)]
                                                          }
                                                          (lam
                                                            ipv
                                                            (con bytestring)
                                                            [
                                                              fail
                                                              (abs
                                                                e
                                                                (type)
                                                                (error e)
                                                              )
                                                            ]
                                                          )
                                                        ]
                                                        (lam
                                                          s
                                                          (con bytestring)
                                                          [
                                                            [
                                                              [
                                                                {
                                                                  [
                                                                    {
                                                                      Maybe_match
                                                                      (con bytestring)
                                                                    }
                                                                    ds
                                                                  ]
                                                                  (fun Unit [[Tuple2 (con bytestring)] (con bytestring)])
                                                                }
                                                                (lam
                                                                  dh
                                                                  (con bytestring)
                                                                  (lam
                                                                    thunk
                                                                    Unit
                                                                    [
                                                                      [
                                                                        {
                                                                          {
                                                                            Tuple2
                                                                            (con bytestring)
                                                                          }
                                                                          (con bytestring)
                                                                        }
                                                                        s
                                                                      ]
                                                                      dh
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                              (lam
                                                                thunk
                                                                Unit
                                                                [
                                                                  fail
                                                                  (abs
                                                                    e
                                                                    (type)
                                                                    (error e)
                                                                  )
                                                                ]
                                                              )
                                                            ]
                                                            Unit
                                                          ]
                                                        )
                                                      ]
                                                    )
                                                  )
                                                ]
                                              )
                                            )
                                          )
                                        ]
                                      )
                                    )
                                  ]
                                )
                              )
                            ]
                            (lam thunk Unit [ fail (abs e (type) (error e)) ])
                          ]
                          Unit
                        ]
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl ownHash (fun ScriptContext (con bytestring)))
                    (lam
                      p
                      ScriptContext
                      [
                        {
                          [
                            {
                              { Tuple2_match (con bytestring) } (con bytestring)
                            }
                            [ ownHashes p ]
                          ]
                          (con bytestring)
                        }
                        (lam a (con bytestring) (lam ds (con bytestring) a))
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      b
                      (fun (con bytestring) [List [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]])
                    )
                    (lam
                      ds
                      (con bytestring)
                      {
                        Nil
                        [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                      }
                    )
                  )
                  (termbind
                    (nonstrict)
                    (vardecl
                      threadTokenValueInner
                      (fun [Maybe ThreadToken] (fun (con bytestring) [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]))
                    )
                    (lam
                      m
                      [Maybe ThreadToken]
                      [
                        [
                          [
                            {
                              [ { Maybe_match ThreadToken } m ]
                              (fun Unit (fun (con bytestring) [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]))
                            }
                            (lam
                              a
                              ThreadToken
                              (lam
                                thunk
                                Unit
                                (let
                                  (nonrec)
                                  (termbind
                                    (nonstrict)
                                    (vardecl currency (con bytestring))
                                    [
                                      {
                                        [ ThreadToken_match a ] (con bytestring)
                                      }
                                      (lam
                                        ds TxOutRef (lam ds (con bytestring) ds)
                                      )
                                    ]
                                  )
                                  (lam
                                    ds
                                    (con bytestring)
                                    [
                                      [
                                        {
                                          Cons
                                          [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                        }
                                        [
                                          [
                                            {
                                              { Tuple2 (con bytestring) }
                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]
                                            }
                                            currency
                                          ]
                                          [
                                            [
                                              {
                                                Cons
                                                [[Tuple2 (con bytestring)] (con integer)]
                                              }
                                              [
                                                [
                                                  {
                                                    { Tuple2 (con bytestring) }
                                                    (con integer)
                                                  }
                                                  ds
                                                ]
                                                (con integer 1)
                                              ]
                                            ]
                                            {
                                              Nil
                                              [[Tuple2 (con bytestring)] (con integer)]
                                            }
                                          ]
                                        ]
                                      ]
                                      {
                                        Nil
                                        [[Tuple2 (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                      }
                                    ]
                                  )
                                )
                              )
                            )
                          ]
                          (lam thunk Unit b)
                        ]
                        Unit
                      ]
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      wmkValidator
                      (all s (type) (all i (type) (fun [(lam a (type) (fun a (con data))) s] (fun (fun [State s] (fun i [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State s]]])) (fun (fun s Bool) (fun (fun s (fun i (fun ScriptContext Bool))) (fun [Maybe ThreadToken] (fun s (fun i (fun ScriptContext Bool))))))))))
                    )
                    (abs
                      s
                      (type)
                      (abs
                        i
                        (type)
                        (lam
                          w
                          [(lam a (type) (fun a (con data))) s]
                          (lam
                            ww
                            (fun [State s] (fun i [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State s]]]))
                            (lam
                              ww
                              (fun s Bool)
                              (lam
                                ww
                                (fun s (fun i (fun ScriptContext Bool)))
                                (lam
                                  ww
                                  [Maybe ThreadToken]
                                  (lam
                                    w
                                    s
                                    (lam
                                      w
                                      i
                                      (lam
                                        w
                                        ScriptContext
                                        (let
                                          (nonrec)
                                          (termbind
                                            (nonstrict)
                                            (vardecl
                                              vl
                                              [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                            )
                                            [
                                              [
                                                [
                                                  {
                                                    [
                                                      { Maybe_match TxInInfo }
                                                      [ findOwnInput w ]
                                                    ]
                                                    (fun Unit [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]])
                                                  }
                                                  (lam
                                                    a
                                                    TxInInfo
                                                    (lam
                                                      thunk
                                                      Unit
                                                      [
                                                        {
                                                          [ TxInInfo_match a ]
                                                          [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                        }
                                                        (lam
                                                          ds
                                                          TxOutRef
                                                          (lam
                                                            ds
                                                            TxOut
                                                            [
                                                              {
                                                                [
                                                                  TxOut_match ds
                                                                ]
                                                                [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                              }
                                                              (lam
                                                                ds
                                                                Address
                                                                (lam
                                                                  ds
                                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                  (lam
                                                                    ds
                                                                    [Maybe (con bytestring)]
                                                                    ds
                                                                  )
                                                                )
                                                              )
                                                            ]
                                                          )
                                                        )
                                                      ]
                                                    )
                                                  )
                                                ]
                                                (lam
                                                  thunk
                                                  Unit
                                                  [
                                                    {
                                                      error
                                                      [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                    }
                                                    [
                                                      {
                                                        [
                                                          Unit_match
                                                          [
                                                            [
                                                              {
                                                                (builtin
                                                                  chooseUnit
                                                                )
                                                                Unit
                                                              }
                                                              [
                                                                (builtin trace)
                                                                (con
                                                                  string
                                                                    "Can't find validation input"
                                                                )
                                                              ]
                                                            ]
                                                            Unit
                                                          ]
                                                        ]
                                                        (con unit)
                                                      }
                                                      (con unit ())
                                                    ]
                                                  ]
                                                )
                                              ]
                                              Unit
                                            ]
                                          )
                                          (termbind
                                            (nonstrict)
                                            (vardecl j Bool)
                                            [
                                              [
                                                [
                                                  {
                                                    [
                                                      {
                                                        Maybe_match
                                                        [[Tuple2 [[TxConstraints Void] Void]] [State s]]
                                                      }
                                                      [
                                                        [
                                                          ww
                                                          [
                                                            [ { State s } w ]
                                                            [
                                                              [
                                                                [
                                                                  unionWith
                                                                  addInteger
                                                                ]
                                                                vl
                                                              ]
                                                              [
                                                                [
                                                                  fAdditiveGroupValue_cscale
                                                                  (con
                                                                    integer -1
                                                                  )
                                                                ]
                                                                [
                                                                  [
                                                                    threadTokenValueInner
                                                                    ww
                                                                  ]
                                                                  [ ownHash w ]
                                                                ]
                                                              ]
                                                            ]
                                                          ]
                                                        ]
                                                        w
                                                      ]
                                                    ]
                                                    (fun Unit Bool)
                                                  }
                                                  (lam
                                                    ds
                                                    [[Tuple2 [[TxConstraints Void] Void]] [State s]]
                                                    (lam
                                                      thunk
                                                      Unit
                                                      [
                                                        {
                                                          [
                                                            {
                                                              {
                                                                Tuple2_match
                                                                [[TxConstraints Void] Void]
                                                              }
                                                              [State s]
                                                            }
                                                            ds
                                                          ]
                                                          Bool
                                                        }
                                                        (lam
                                                          newConstraints
                                                          [[TxConstraints Void] Void]
                                                          (lam
                                                            ds
                                                            [State s]
                                                            [
                                                              {
                                                                [
                                                                  {
                                                                    State_match
                                                                    s
                                                                  }
                                                                  ds
                                                                ]
                                                                Bool
                                                              }
                                                              (lam
                                                                ds
                                                                s
                                                                (lam
                                                                  ds
                                                                  [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] [[(lam k (type) (lam v (type) [List [[Tuple2 k] v]])) (con bytestring)] (con integer)]]
                                                                  [
                                                                    [
                                                                      [
                                                                        {
                                                                          [
                                                                            Bool_match
                                                                            [
                                                                              ww
                                                                              ds
                                                                            ]
                                                                          ]
                                                                          (fun Unit Bool)
                                                                        }
                                                                        (lam
                                                                          thunk
                                                                          Unit
                                                                          (let
                                                                            (nonrec
                                                                            )
                                                                            (termbind
                                                                              (nonstrict
                                                                              )
                                                                              (vardecl
                                                                                j
                                                                                Bool
                                                                              )
                                                                              [
                                                                                [
                                                                                  [
                                                                                    {
                                                                                      [
                                                                                        Bool_match
                                                                                        [
                                                                                          [
                                                                                            [
                                                                                              {
                                                                                                {
                                                                                                  checkScriptContext
                                                                                                  Void
                                                                                                }
                                                                                                Void
                                                                                              }
                                                                                              fToDataVoid_ctoBuiltinData
                                                                                            ]
                                                                                            newConstraints
                                                                                          ]
                                                                                          w
                                                                                        ]
                                                                                      ]
                                                                                      (fun Unit Bool)
                                                                                    }
                                                                                    (lam
                                                                                      thunk
                                                                                      Unit
                                                                                      True
                                                                                    )
                                                                                  ]
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    [
                                                                                      [
                                                                                        {
                                                                                          (builtin
                                                                                            chooseUnit
                                                                                          )
                                                                                          Bool
                                                                                        }
                                                                                        [
                                                                                          (builtin
                                                                                            trace
                                                                                          )
                                                                                          (con
                                                                                            string
                                                                                              "State transition invalid - constraints not satisfied by ScriptContext"
                                                                                          )
                                                                                        ]
                                                                                      ]
                                                                                      False
                                                                                    ]
                                                                                  )
                                                                                ]
                                                                                Unit
                                                                              ]
                                                                            )
                                                                            [
                                                                              [
                                                                                [
                                                                                  {
                                                                                    [
                                                                                      Bool_match
                                                                                      [
                                                                                        isZero
                                                                                        ds
                                                                                      ]
                                                                                    ]
                                                                                    (fun Unit Bool)
                                                                                  }
                                                                                  (lam
                                                                                    thunk
                                                                                    Unit
                                                                                    j
                                                                                  )
                                                                                ]
                                                                                (lam
                                                                                  thunk
                                                                                  Unit
                                                                                  [
                                                                                    [
                                                                                      [
                                                                                        {
                                                                                          [
                                                                                            Bool_match
                                                                                            [
                                                                                              [
                                                                                                {
                                                                                                  (builtin
                                                                                                    chooseUnit
                                                                                                  )
                                                                                                  Bool
                                                                                                }
                                                                                                [
                                                                                                  (builtin
                                                                                                    trace
                                                                                                  )
                                                                                                  (con
                                                                                                    string
                                                                                                      "Non-zero value allocated in final state"
                                                                                                  )
                                                                                                ]
                                                                                              ]
                                                                                              False
                                                                                            ]
                                                                                          ]
                                                                                          (fun Unit Bool)
                                                                                        }
                                                                                        (lam
                                                                                          thunk
                                                                                          Unit
                                                                                          j
                                                                                        )
                                                                                      ]
                                                                                      (lam
                                                                                        thunk
                                                                                        Unit
                                                                                        False
                                                                                      )
                                                                                    ]
                                                                                    Unit
                                                                                  ]
                                                                                )
                                                                              ]
                                                                              Unit
                                                                            ]
                                                                          )
                                                                        )
                                                                      ]
                                                                      (lam
                                                                        thunk
                                                                        Unit
                                                                        [
                                                                          [
                                                                            [
                                                                              {
                                                                                [
                                                                                  Bool_match
                                                                                  [
                                                                                    [
                                                                                      [
                                                                                        {
                                                                                          {
                                                                                            checkScriptContext
                                                                                            Void
                                                                                          }
                                                                                          s
                                                                                        }
                                                                                        w
                                                                                      ]
                                                                                      [
                                                                                        {
                                                                                          [
                                                                                            {
                                                                                              {
                                                                                                TxConstraints_match
                                                                                                Void
                                                                                              }
                                                                                              Void
                                                                                            }
                                                                                            newConstraints
                                                                                          ]
                                                                                          [[TxConstraints Void] s]
                                                                                        }
                                                                                        (lam
                                                                                          ds
                                                                                          [List TxConstraint]
                                                                                          (lam
                                                                                            ds
                                                                                            [List [InputConstraint Void]]
                                                                                            (lam
                                                                                              ds
                                                                                              [List [OutputConstraint Void]]
                                                                                              [
                                                                                                [
                                                                                                  [
                                                                                                    {
                                                                                                      {
                                                                                                        TxConstraints
                                                                                                        Void
                                                                                                      }
                                                                                                      s
                                                                                                    }
                                                                                                    ds
                                                                                                  ]
                                                                                                  ds
                                                                                                ]
                                                                                                [
                                                                                                  {
                                                                                                    build
                                                                                                    [OutputConstraint s]
                                                                                                  }
                                                                                                  (abs
                                                                                                    a
                                                                                                    (type)
                                                                                                    (lam
                                                                                                      c
                                                                                                      (fun [OutputConstraint s] (fun a a))
                                                                                                      (lam
                                                                                                        n
                                                                                                        a
                                                                                                        [
                                                                                                          [
                                                                                                            c
                                                                                                            [
                                                                                                              [
                                                                                                                {
                                                                                                                  OutputConstraint
                                                                                                                  s
                                                                                                                }
                                                                                                                ds
                                                                                                              ]
                                                                                                              [
                                                                                                                [
                                                                                                                  [
                                                                                                                    unionWith
                                                                                                                    addInteger
                                                                                                                  ]
                                                                                                                  ds
                                                                                                                ]
                                                                                                                [
                                                                                                                  [
                                                                                                                    threadTokenValueInner
                                                                                                                    ww
                                                                                                                  ]
                                                                                                                  [
                                                                                                                    ownHash
                                                                                                                    w
                                                                                                                  ]
                                                                                                                ]
                                                                                                              ]
                                                                                                            ]
                                                                                                          ]
                                                                                                          n
                                                                                                        ]
                                                                                                      )
                                                                                                    )
                                                                                                  )
                                                                                                ]
                                                                                              ]
                                                                                            )
                                                                                          )
                                                                                        )
                                                                                      ]
                                                                                    ]
                                                                                    w
                                                                                  ]
                                                                                ]
                                                                                (fun Unit Bool)
                                                                              }
                                                                              (lam
                                                                                thunk
                                                                                Unit
                                                                                True
                                                                              )
                                                                            ]
                                                                            (lam
                                                                              thunk
                                                                              Unit
                                                                              [
                                                                                [
                                                                                  {
                                                                                    (builtin
                                                                                      chooseUnit
                                                                                    )
                                                                                    Bool
                                                                                  }
                                                                                  [
                                                                                    (builtin
                                                                                      trace
                                                                                    )
                                                                                    (con
                                                                                      string
                                                                                        "State transition invalid - constraints not satisfied by ScriptContext"
                                                                                    )
                                                                                  ]
                                                                                ]
                                                                                False
                                                                              ]
                                                                            )
                                                                          ]
                                                                          Unit
                                                                        ]
                                                                      )
                                                                    ]
                                                                    Unit
                                                                  ]
                                                                )
                                                              )
                                                            ]
                                                          )
                                                        )
                                                      ]
                                                    )
                                                  )
                                                ]
                                                (lam
                                                  thunk
                                                  Unit
                                                  [
                                                    [
                                                      {
                                                        (builtin chooseUnit)
                                                        Bool
                                                      }
                                                      [
                                                        (builtin trace)
                                                        (con
                                                          string
                                                            "State transition invalid - input is not a valid transition at the current state"
                                                        )
                                                      ]
                                                    ]
                                                    False
                                                  ]
                                                )
                                              ]
                                              Unit
                                            ]
                                          )
                                          (termbind
                                            (nonstrict)
                                            (vardecl j Bool)
                                            [
                                              [
                                                [
                                                  {
                                                    [
                                                      {
                                                        Maybe_match ThreadToken
                                                      }
                                                      ww
                                                    ]
                                                    (fun Unit Bool)
                                                  }
                                                  (lam
                                                    threadToken
                                                    ThreadToken
                                                    (lam
                                                      thunk
                                                      Unit
                                                      [
                                                        [
                                                          [
                                                            {
                                                              [
                                                                Bool_match
                                                                [
                                                                  [
                                                                    [
                                                                      {
                                                                        (builtin
                                                                          ifThenElse
                                                                        )
                                                                        Bool
                                                                      }
                                                                      [
                                                                        [
                                                                          (builtin
                                                                            equalsInteger
                                                                          )
                                                                          [
                                                                            [
                                                                              [
                                                                                valueOf
                                                                                vl
                                                                              ]
                                                                              [
                                                                                {
                                                                                  [
                                                                                    ThreadToken_match
                                                                                    threadToken
                                                                                  ]
                                                                                  (con bytestring)
                                                                                }
                                                                                (lam
                                                                                  ds
                                                                                  TxOutRef
                                                                                  (lam
                                                                                    ds
                                                                                    (con bytestring)
                                                                                    ds
                                                                                  )
                                                                                )
                                                                              ]
                                                                            ]
                                                                            [
                                                                              ownHash
                                                                              w
                                                                            ]
                                                                          ]
                                                                        ]
                                                                        (con
                                                                          integer
                                                                            1
                                                                        )
                                                                      ]
                                                                    ]
                                                                    True
                                                                  ]
                                                                  False
                                                                ]
                                                              ]
                                                              (fun Unit Bool)
                                                            }
                                                            (lam thunk Unit j)
                                                          ]
                                                          (lam
                                                            thunk
                                                            Unit
                                                            [
                                                              [
                                                                [
                                                                  {
                                                                    [
                                                                      Bool_match
                                                                      [
                                                                        [
                                                                          {
                                                                            (builtin
                                                                              chooseUnit
                                                                            )
                                                                            Bool
                                                                          }
                                                                          [
                                                                            (builtin
                                                                              trace
                                                                            )
                                                                            (con
                                                                              string
                                                                                "Thread token not found"
                                                                            )
                                                                          ]
                                                                        ]
                                                                        False
                                                                      ]
                                                                    ]
                                                                    (fun Unit Bool)
                                                                  }
                                                                  (lam
                                                                    thunk Unit j
                                                                  )
                                                                ]
                                                                (lam
                                                                  thunk
                                                                  Unit
                                                                  False
                                                                )
                                                              ]
                                                              Unit
                                                            ]
                                                          )
                                                        ]
                                                        Unit
                                                      ]
                                                    )
                                                  )
                                                ]
                                                (lam thunk Unit j)
                                              ]
                                              Unit
                                            ]
                                          )
                                          [
                                            [
                                              [
                                                {
                                                  [
                                                    Bool_match
                                                    [ [ [ ww w ] w ] w ]
                                                  ]
                                                  (fun Unit Bool)
                                                }
                                                (lam thunk Unit j)
                                              ]
                                              (lam
                                                thunk
                                                Unit
                                                [
                                                  [
                                                    [
                                                      {
                                                        [
                                                          Bool_match
                                                          [
                                                            [
                                                              {
                                                                (builtin
                                                                  chooseUnit
                                                                )
                                                                Bool
                                                              }
                                                              [
                                                                (builtin trace)
                                                                (con
                                                                  string
                                                                    "State transition invalid - checks failed"
                                                                )
                                                              ]
                                                            ]
                                                            False
                                                          ]
                                                        ]
                                                        (fun Unit Bool)
                                                      }
                                                      (lam thunk Unit j)
                                                    ]
                                                    (lam thunk Unit False)
                                                  ]
                                                  Unit
                                                ]
                                              )
                                            ]
                                            Unit
                                          ]
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      mkValidator
                      (all s (type) (all i (type) (fun [(lam a (type) (fun a (con data))) s] (fun [[StateMachine s] i] (fun s (fun i (fun ScriptContext Bool)))))))
                    )
                    (abs
                      s
                      (type)
                      (abs
                        i
                        (type)
                        (lam
                          w
                          [(lam a (type) (fun a (con data))) s]
                          (lam
                            w
                            [[StateMachine s] i]
                            (lam
                              w
                              s
                              (lam
                                w
                                i
                                (lam
                                  w
                                  ScriptContext
                                  [
                                    {
                                      [ { { StateMachine_match s } i } w ] Bool
                                    }
                                    (lam
                                      ww
                                      (fun [State s] (fun i [Maybe [[Tuple2 [[TxConstraints Void] Void]] [State s]]]))
                                      (lam
                                        ww
                                        (fun s Bool)
                                        (lam
                                          ww
                                          (fun s (fun i (fun ScriptContext Bool)))
                                          (lam
                                            ww
                                            [Maybe ThreadToken]
                                            [
                                              [
                                                [
                                                  [
                                                    [
                                                      [
                                                        [
                                                          [
                                                            {
                                                              { wmkValidator s }
                                                              i
                                                            }
                                                            w
                                                          ]
                                                          ww
                                                        ]
                                                        ww
                                                      ]
                                                      ww
                                                    ]
                                                    ww
                                                  ]
                                                  w
                                                ]
                                                w
                                              ]
                                              w
                                            ]
                                          )
                                        )
                                      )
                                    )
                                  ]
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                  (termbind
                    (strict)
                    (vardecl
                      mkValidator
                      (fun Params (fun MSState (fun Input (fun ScriptContext Bool))))
                    )
                    (lam
                      params
                      Params
                      [
                        [
                          { { mkValidator MSState } Input }
                          fToDataMSState_ctoBuiltinData
                        ]
                        [ machine params ]
                      ]
                    )
                  )
                  mkValidator
                )
              )
            )
          )
        )
      )
    )
  )
)