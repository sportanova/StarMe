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
        console.log('data', data)
      })
    }
  },
  componentDidMount: function() {
    this.getRepos(this.props.username, this.props.repoType)
  },
  render: function() {
    var repoNodes = this.state.repos.map(function(repo) {
      return (
        <Repo data={repo} key={Math.random()}/>
      )
    });

    return (
      <div>
        {repoNodes}
      </div>
    );
  }
});