<template>
	<body id="app">
    <!-- begin:: Page -->
        <div id="page_content_main">
            <!-- BEGIN: Header -->
            <header data-minimize-offset="200" data-minimize-mobile-offset="200" >
				<div>
				    <div>
				        <!-- BEGIN: Brand -->
				        <div>
				            <div>
				                <div>
				                     <a href="javascript:;">
				                        <img alt="" src="https://evercam.io/wp-content/uploads/2016/07/Favicon-150.png" />
				                    </a>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>
			</header>
        <div>
				<div id="m_aside_left">
				  <!-- BEGIN: Aside Menu -->
				  <div id="m_ver_menu" data-menu-vertical="true" data-menu-scrollable="false" data-menu-dropdown-timeout="500">
				     <ul>
				         <li>
									<router-link v-bind:to="'/timelapse'">
										<i class="fa fa-newspaper-o"></i>
										<span>Timelapse</span>
									</router-link>
				        </li>
				        <li>
									<router-link v-bind:to="'/gallery'">
										<i class="fas fa-file-video"></i>
										<span>Gallery</span>
									</router-link>
				        </li>
				    </ul>
				    <ul>
				        <li>
				            <a  href="/session">
				                <i class="fa fa-power-off"></i>
				                <span>
				                    <span>
				                        <span>
				                            Logout
				                        </span>
				                    </span>
				                </span>
				            </a>
				        </li>
				    </ul>
				  </div>
				  <!-- END: Aside Menu -->
				</div>
                <!-- END: Left Aside -->
                <div id="remote_data">
									<notifications group="notify" />
									<router-view></router-view>
                </div>
            </div>
        </div>
            <!-- end:: Body -->
        <!-- begin::Scroll Top -->
        <div data-scroll-offset="500" data-scroll-speed="300">
            <i class="la la-arrow-up"></i>
        </div>
        <!-- end::Scroll Top -->
    </div>
    <!-- end:: Page -->
</body>
</template>

<script>
export default {
  name: 'app'
	
}
</script>

<style lang="scss">
@import '../css/app.scss';
</style>
