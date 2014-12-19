var Repos = React.createClass({
  getInitialState: function() {
    return {
      repos: []
    }
  },
  getRepos: function(username, repoType) {
    if(repoType === 'public') {
      var that = this;

      this.setState({repos: repoData});

      // $.ajax({
      //   type: "GET",
      //   url: "https://api.github.com/users/" + username + "/repos?sort=updated"
      // }).then(function(data) {
      //   that.setState({repos: data});
      // })
    }
    else if(repoType === 'selected') {
      var that = this;

      $.ajax({
        type: "GET",
        url: "/repos/username/sportanova?starred=false"
      }).then(function(data) {
        that.setState({repos: data});
      })
    }
  },
  removeRepo: function(index) {
    var newRepos = this.state.repos.slice();
    newRepos.splice(index, 1);

    this.setState({repos: newRepos});
  },
  addRepo: function(repo) {
    var newRepos = this.state.repos.slice();
    newRepos.push(repo);

    this.setState({repos: newRepos});
  },
  componentDidMount: function() {
    var that = this;

    this.getRepos(this.props.username, this.props.repoType)

    if(this.props.repoType === 'public') {
      document.body.addEventListener('addPublicRepo', function (e) {
        that.addRepo(e.detail);
      }, false);
    }
    else if(this.props.repoType === 'selected') {
      document.body.addEventListener('addSelectedRepo', function (e) {
        that.addRepo(e.detail);
      }, false);
    }
  },
  componentWillUnmount: function() {
    document.body.removeEventListener('addPublicRepo', function (e) {
      that.addRepo(e.detail);
    }, false);

    document.body.removeEventListener('addSelectedRepo', function (e) {
      that.addRepo(e.detail);
    }, false);
  },
  render: function() {
    var that = this;
    var repoNodes = this.state.repos.map(function(repo, i) {
      return (
        <Repo data={repo} repoType={that.props.repoType} removeRepo={that.removeRepo} key={Math.random()} index={i}/>
      )
    });

    return (
      <div className='repos'>
        {repoNodes}
      </div>
    );
  }
});