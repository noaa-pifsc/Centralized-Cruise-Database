echo "compare all automated verification files with the output of the test cases:"
fc category_1_CRDMA_CDVM_issue_verification.csv category_1_CRDMA_CDVM_issue_verification-2.csv > file_compare_script_output_verification-2.txt
echo ""
echo ""
fc file_compare_script_output_verification.txt file_compare_script_output_verification-2.txt > summary_verification_results.txt
pause