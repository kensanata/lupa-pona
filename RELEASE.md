# What to do for a release?

Run `make README.md`.

Update `Changes` with user-visible changes.

Check the copyright year in the `LICENSE`.

Increase the version in `lib/App/lupapona.pm`.

Use n.nn_nn for developer releases:

```
make distdir
mv App-lupapona-1.06 App-lupapona-1.06_00
tar czf App-lupapona-1.06_00.tar.gz App-lupapona-1.06_00
```

Double check the `MANIFEST`. Did we add new files that should be in
here?

```
make manifest
```

Commit any changes and tag the release.

Based on [How to upload a script to
CPAN](https://www.perl.com/article/how-to-upload-a-script-to-cpan/) by
David Farrell (2016):

```
perl Makefile.PL && make && make dist
cpan-upload -u SCHROEDER App-lupapona-1.00.tar.gz
```
