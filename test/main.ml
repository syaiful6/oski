let () = Alcotest.run "Oski" (List.flatten [ Test_ffi.tests; Test_oski.tests ])
