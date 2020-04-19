
#include "absl/flags/flag.h"
#include "absl/flags/parse.h"
#include "git2.h"
#include <assert.h>
#include <iostream>

ABSL_FLAG(std::string, output_dir, "foo/bar/baz/", "output file dir");

int main(int argc, char** argv)
{
  absl::ParseCommandLine(argc, argv);

  git_libgit2_init();

  git_repository *repo = NULL;
  int error = git_repository_open(&repo, "/xo");
  assert(error == 0);

  const char *sha = "f95f66bef3304140ea8bd5665cfb7761285f1b0e";
  git_oid oid = {0};
  error = git_oid_fromstr(&oid, sha);
  assert(error == 0);

  git_commit *commit;
  error = git_commit_lookup(&commit, repo, &oid);
  assert(error == 0);
  
  git_tree *tree = NULL;
  git_commit_tree(&tree, commit); 

  size_t count = git_tree_entrycount(tree);

  for(size_t i = 0; i < count; i++) {
    const git_tree_entry *entry = git_tree_entry_byindex(tree, i);
    const char *name = git_tree_entry_name(entry);
    std::cout << name << "\n";
  }

  return 0;
}