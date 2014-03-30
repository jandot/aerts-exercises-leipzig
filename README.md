# aerts-exercises-leipzig

Database and visualization exercises for Leipzig course "Programming for Evolutionary Biology"

## Management

Latest versions of the files are in git repository http://github.com/jandot/aerts-exercises-leipzig

The repository is cloned onto the evopserver in /homes/evopserver/jan, and we create symbolic links in the lectures directories:

    cd /homes/evopserver/lectures/Databases
    ln -s /homes/evopserver/jan/aerts-exercises-leipzig/Databases/databases.html .
    ln -s /homes/evopserver/jan/aerts-exercises-leipzig/Databases/primary_foreign_keys.png .
    cd /homes/evopserver/lectures/Databases/exercises
    ln -s /homes/evopserver/jan/aerts-exercises-leipzig/Databases/exercises/* .
    cd /homes/evopserver/lectures/Visualization
    ln -s /homes/evopserver/jan/aerts-exercises-leipzig/Visualization/VisualAnalytics.pdf .
    ln -s /homes/evopserver/jan/aerts-exercises-leipzig/Visualization/structural_variation.gvf .
    ln -s /homes/evopserver/jan/aerts-exercises-leipzig/Visualization/practical.pdf .

### Tagging

At the end of each course, tag the last git repository

    git tag -a v1.1 -m 'Version 2014'
    git push origin --tags

### Versions

    v1.0 => 2013
