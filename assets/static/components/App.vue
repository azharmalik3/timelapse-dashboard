<template>
	<span>
		<header class="app-header navbar">
			<button class="navbar-toggler sidebar-toggler d-lg-none mr-auto" type="button" data-toggle="sidebar-show">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	    <a class="navbar-brand" href="#">
	      <img class="navbar-brand-full" src="/images/evercam-logo-2.png" width="110" height="25" alt="Evercam Logo">
	      <img class="navbar-brand-minimized" src="/images/Favicon-300.png" width="30" height="30" alt="Evercam Logo">
	    </a>
	    <button class="navbar-toggler sidebar-toggler d-md-down-none" type="button" data-toggle="sidebar-lg-show">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	    <ul class="nav navbar-nav ml-auto">
	      <li class="nav-item dropdown">
	        <a class="nav-link" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
	          <img class="img-avatar" src="/images/avatar.png" alt="javier@evercam.io">
	        </a>
	        <div class="dropdown-menu dropdown-menu-right">
	          <div class="dropdown-header text-center">
	            <strong>Account</strong>
	          </div>
	          <div class="dropdown-divider"></div>
	          <a class="dropdown-item" href="/session">
	            <i class="fa fa-lock"></i> Logout</a>
	        </div>
	      </li>
	    </ul>
	  </header>
		<div class="app-body">
			<div class="sidebar">
				<nav class="sidebar-nav">
					<ul class="nav">
						<li class="nav-item">
							<a class="nav-link" href="/timelapse">
								<i class="nav-icon fa fa-tachometer"></i> Dashboard
							</a>
						</li>
						<li class="nav-title">Timelapse</li>
						<li class="nav-item">
							<router-link class="nav-link" v-bind:to="'/timelapse'">
								<i class="nav-icon icon-drop fa fa-clock-o"></i>
								Timelapse
							</router-link>
						</li>
						<li class="nav-item">
							<router-link class="nav-link" v-bind:to="'/gallery'">
								<i class="nav-icon icon-drop fa fa-video-camera"></i>
								Gallery
							</router-link>
						</li>
					</ul>
				</nav>
				<button class="sidebar-minimizer brand-minimizer" type="button"></button>
			</div>
			<main id="app" class="main">
				<div id="remote_data">
					<notifications group="notify" />
					<router-view></router-view>
				</div>
			</main>
		</div>
	</span>
</template>

<script>
export default {
  name: 'app'

}
</script>

<style lang="scss">
@import '../css/app.scss';
</style>
