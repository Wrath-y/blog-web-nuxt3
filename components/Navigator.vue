<template>
    <div class="navtop">
        <div class="logo"></div>
        <el-menu router class="navbar" mode="horizontal">
            <el-menu-item class="nav-index" index="/">首页</el-menu-item>
            <el-sub-menu :show-timeout='100' :hide-timeout='100' index="/list">
                <template #title>杂七杂八的清单</template>
                <el-menu-item class="nav-music" index="/list/music">歌单</el-menu-item>
                <el-menu-item class="nav-pic" index="/list/pixiv">图片</el-menu-item>
                <!-- <el-menu-item class="nav-chat" index="/lists/chats">chat</el-menu-item> -->
            </el-sub-menu>
            <el-menu-item class="nav-message" index="/messages">留言板</el-menu-item>
            <el-menu-item class="nav-friends" index="/friends">友人帐</el-menu-item>
            <el-menu-item class="nav-about" index="/about">关于我</el-menu-item>
        </el-menu>
    </div>
</template>

<script>
export default {
    components: {
    },
    data() {
        return {
        };
    },
    computed: {},
    watch: {},
    methods: {},
    mounted() {
    },
    beforeDestroy() {
    },
};
</script>

<style lang="scss">
.navtop {
    position: fixed;
    width: 100%;
    z-index: 9999;
}

.navbar {
    font-family: 'Source Han Serif SC', 'Source Han Serif', 'source-han-serif-sc', 'PT Serif', 'SongTi SC', 'MicroSoft Yahei', Georgia, serif;
    display: flex;
    justify-content: center;
}

.el-menu .el-submenu,
.el-menu--horizontal .el-menu--popup {
    min-width: 158px;
    border-radius: 8px;
    overflow: hidden;

    .el-menu-item {
        text-align: center;
    }

    .el-menu-item:hover {
        color: #e67474 !important;
        text-decoration: none;
        cursor: url(https://gilgamesh-10047150.cos.ap-shanghai.myqcloud.com/ayuda.cur), auto;
    }
}
</style>
