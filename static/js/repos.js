var Repos = React.createClass({
  getInitialState: function() {
    return {
      repos: [],
      savedRepos: []
    }
  },
  getRepos: function(username) {
    var that = this;

    $.ajax({
      type: "GET",
      url: "/repos/username/" + username
    }).then(function(data) {
      that.combineDataAndRepos(data, that.state.repos);
    })

    this.setState({repos: repoData});

      // $.ajax({
      //   type: "GET",
      //   url: "https://api.github.com/users/" + username + "/repos?sort=updated&per_page=100"
      // }).then(function(data) {
      //   that.setState({repos: data});
      // })
  },
  combineDataAndRepos: function(data, repos) {
    if(data.length && repos.length) {
      var data1 = _.reduce(data, function(acc, repo) {
        acc[repo.name] = repo;
        return acc;
      }, {});

      var repos1 = _.map(repos, function(repo) {
        if(data1[repo.name]) {
          return _.extend(repo, data1[repo.name])
        }
        else return repo;
      });

      this.setState({repos: repos1});
    }
  },
  saveRepos: function(repos) {
    var that = this;

    var reposToSave = _.filter(repos, function(repo) {
      if(!repo.hasOwnProperty('starred') && repo.isChecked) {
        return true;
      }
    }).map(function(repo) {
      return {
        username: that.props.username,
        name: repo.name
      }
    });

    $.ajax({
      type: "POST",
      url: "/repos/username/" + this.props.username,
      data: JSON.stringify(reposToSave)
    })
  },
  componentDidMount: function() {
    this.getRepos(this.props.username, this.props.repoType)
  },
  repoIsChecked: function(repo) {
    if(repo.hasOwnProperty('starred')) return true;
    if(repo.isChecked) return true;
  },
  toggleCheckBox: function(repo) {
    var that = this;
    return function(isChecked) {
      repo.isChecked = isChecked;
      var repos1 = _.map(that.state.repos, function(repo1) {
        if(repo1.name === repo.name) {
          return repo;
        }
        else {
          return repo1;
        }
      })

      that.setState({repos: repos1})
    }
  },
  componentWillUnmount: function() {
  },
  render: function() {
    var that = this;
    var repoNodes = this.state.repos.map(function(repo, i) {
      return (
        <Repo data={repo} key={Math.random()} isChecked={that.repoIsChecked(repo)} toggleCheckboxCB={that.toggleCheckBox(repo)} savedRepos={that.state.savedRepos} index={i}/>
      )
    });

    return (
      <div className='repos'>
        {repoNodes}
        <button onClick={this.saveRepos.bind(this, this.state.repos)}>Save</button>
      </div>
    );
  }
});